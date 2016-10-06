---
title: 对象池、链接池
date: 2015-11-20 16:09
categories: programming
tags:
- design
- ruby
---
起因：有同事说某个接口返回的信息不一致，作为接口的维护者我需要来修正这个问题

故事是这样的：

背景：今有一ruby的web项目（使用sinatra作为框架），提供了一个接口 `/search/:album_id` 根据 `album_id` 来查询一些信息（json格式），
并且返回json中包含 `album_id`

## 首先要确定问题确实是在我这边
写一个脚本，多线程来调用接口，并验证调用参数与返回参数的一致性，
1. 当使用thin来启动的时候，脚本跑下来发现提供的查询 `album_id` 和返回信息中的 `album_id` 是相同，尝试多次数据始终是一致的
2. 当使用unicorn（unicorn是用单进程的）来启动的时候，结果同上
这让我滋生了一个怀疑，问题确实是在我这边吗？

我想起线上的unicorn是多进程的，所以用unicorn的多进程来起项目，再跑脚本，真相出现了，问题确实在我这边

## 寻找问题的原因与解决方案
我将提供接口的代码反复查看，实在是没看出什么，因为代码确实很短，不到30行，打印处了返回的json，
我将搜索的 `album_id` 限定到2个的时候，这个问题依然存在，只是能确定有问题，却不知道原因，
在不清楚原因的情况下，我做起了一些假设，并添加了mutex来做同步，发现问题依然存在。

几番折腾无果之后，请教身旁的主管，老大一上来就指出了一处代码的不合理
```ruby
# 原作
json(pss.map{|p| p.to_json}.inject{|acc, item| acc.merge!(item); acc }, :encoder => :to_json, :content_type => :js)
# 修改后
json(pss.map{|p| p.to_json}.inject(:merge), :encoder => :to_json, :content_type => :js)
```
修改的原因是不immutable，虽然可能于结果没什么帮助，但确实是一处值得修改的地方。  \\
我们在代码的多处打印了进程ID（此时unicorn是用多进程模式），发现并没有出现交错的情况。
更有甚者我们在接口进入处生成一个随机函数，一番折腾但依然无果。

老大又查看了unicorn的配置，数据库的配置等。没发现什么可疑之处。中间一个有趣的插曲是在出现多次的数据不一致之后，数据又一致了。
我们面面相觑。。。。

接着让我在接口代码中，多处打印传入参数，返回的结果以更加暴露问题。这一打印让我们本以为数据应该一致的地方，出现了不一致。
``` ruby
get '/search/:album_id' do 
  #1  puts params[:album_id]
  pss = ProfitSharingScheme.where(album_id: params[:album_id]) # 会查到最多两条纪录
  #2 puts pss.first.album_id
  if pss.first
    js = json(pss.map{|p| p.to_json}.inject(:merge), :encoder => :to_json, :content_type => :js)
    if JSON.parse(js)["album_id"] == params[:album_id]
      puts "#{params[:album_id]}  -- OK"
    else
  #3  puts "#{params[:album_id]}  -- #{js}"
    end
  else
    ...
  end
end
```
以上代码中 `#` 标出的地方 `params[:album_id], pss.first.album_id, js` 中的 `album_id` 这三个值有时会出现不一样的情况
由于只有两个 `album_id` 所以三处不一致还是可以表现出来。

接着老大查了下sequel（使用的ORM）的文档，提出了如下修改：
``` ruby
pss = ProfitSharingScheme.where(album_id: params[:album_id]) # 会查到最多两条纪录
# 改成如下
pss = ProfitSharingScheme.where(album_id: params[:album_id]).to_a # 会查到最多两条纪录
```
原因是不加 `to_a` 的时候，数据其实没有拿出来，会导致后面的 `pss.first` 和 `json(pss.map.....)` 会查询两次数据库，
（sequel并不会对结果进行缓存，两次调用）

果然，修改之后的代码，数据不一致只出现在了 #1和#2处，#2和#3的 `album_id` 始终保持一致。此时距离目标似乎近了一步。

老大此时我新加了一个测试，
``` ruby
get "/search2/:album_id" do
  aid = params[:album_id].to_i
  ds = BodyContent.where(album_id: aid)
  datalist = ds.to_a
  if datalist.empty?
    puts "#{aid} ... empty"
  elsif datalist[0].album_id == aid then
    puts "#{aid} ---- OK"
  else
    puts "#{aid} ....... #{datalist}  .... #{ds.inspect}" 
  end
  %Q<{"album_id": #{datalist[0].album_id}}>
end
```
换了一个更简单的接口来做测试，重现问题。当然也只是再现了这个问题。

老大让我对sequel直接来做测试，传入 `album_id` 验证拿出的数据的 `album_id` 和 传入的数据。

结果数据是一致的，老大宣布了sequel的无罪

我无意中在 `if` 之前加了一个 `sleep` 脚本的测试就通过了，试了几次之后还是OK。
这个发现报告给老大后并加以演示，在 `if` 前加了句： `1_000_000.times{}` 。   
老大试着使用 `datalist.freeze` 来达到相同的效果，却不行。
之后添加了如下代码：
``` ruby
good_count = 100.times.map do
  ds.all[0].album_id
end.count {|x| x == aid}
puts "++++++++ #{aid} ++++++++ #{good_count}"

datalist = ds.all
# 1_000_000.times{}
```
发现 `good_count` 的值并不总是100。我们依然无法解释这个情况。

老大此时让我先把数据库的查询部分用 `ActiveRecord` 来做，再看看情况。
当我正干劲十足的改代码时，老大来了一长串话，大意就是，unicorn在fork进程的时候，
各个进程的连接池出现了混乱，才会导致数据不一致的问题，而之所以经过几次失败后好了，
可能是各个进程建立了自己的连接池。

让我眼前一亮。接着在老大的指导下我修改了unicorn的配置，
``` ruby
before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end

  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
  defined?(Copyright::DB_COPYRIGHT) and Copyright::DB_COPYRIGHT.disconnect
  sleep 1
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.reconnect!
  defined?(Copyright::DB_COPYRIGHT) and 
    Copyright::DB_COPYRIGHT.connect(Settings.copyright)
end
```
在原有的 `ActiveRecord` 配置下，添加了 `Copyright::DB_COPYRIGHT` 配置。再经测试，通过！
颇有众里寻它千百度的感觉。我问老大怎么会突然想到这个，老大说是看sequel的连接池时突然想到的。
或许这就是积累和灵感吧。

之后我向老大请教了数据库连接池的问题。我听完后，感触最深的是连接池保护了数据库。我做了如下图来表示：
``` ditaa
    ------------------------ 
  /   pool                  \
 |     +--------------+      |
 |     | object/db    |      |
 |     +--------------+      |
  \             pool        /        
   -------------------------
```

## 总结
一番磨难之后，自己学到了很多东西。发现路还很长。
