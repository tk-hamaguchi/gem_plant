# encoding: utf-8
 
 
前提 /^プロジェクトルートにいる$/ do
  `pwd`.strip.should == @features_root
end
 
前提 /^ディレクトリ"(.*?)"が削除されている$/ do |path|
  FileUtils.rm_rf path
  check_directory_presence([path], false)
end
 
もし /^rakeタスク"(.*?)"を実行する$/ do |task_name|
  run_simple "rake #{task_name}"
end
 
 
ならば /^終了コードが"(.*?)"である$/ do |exit_status|
  assert_exit_status(exit_status.to_i)
end
 
ならば /^標準出力が下記の正規表現にマッチする:$/ do |expected|
  assert_matching_output(expected, all_stdout)
end
 
ならば /^ディレクトリ"(.*?)"が存在して(いる|いない)$/ do |directory,presence|
  check_directory_presence([directory], (presence == "いる"))
end
 
ならば /^下記のファイルが存在している:$/ do |files|
  check_file_presence(files.raw.map{|file_row| file_row[0]}, true)
end
