# sarch_component.rb
# componentがどこで使用されているか検索する

# 検索したいcomponent名を第一引数にする
# ex.) ruby search_component.rb component_name
return if ARGV.length == 0
search_component = ARGV[0]

target_dir = "/Users/....."

# componentディレクトリ配下
def search_component (component_name, target_dir)
  used_component_files = []
  first_flg = true
  tmp_files = {}
  component_dir = target_dir + "/components"
  Dir.glob('**/*', File::FNM_DOTMATCH, base: component_dir).each do |file|
    file_path = File.join(component_dir, file)
    if File.extname(file) == '.vue'
      File.foreach(file_path, :external_encoding => "UTF-8") do |line|
        if line.include?('<' + component_name) && first_flg
          tmp_files = { file: file, code: [line], pearents: [] }
          first_flg = false
        elsif line.include?('<' + component_name)
          # 複数箇所で使われている場合
          tmp_files[:code] << line
        end
      end
      unless first_flg
        pearent_component_name = File.basename(file, ".*")
        # 親のコンポーネント名で検索
        tmp_files[:pearents] << search_component(pearent_component_name, target_dir)
        used_component_files << tmp_files
        tmp_files = {}
      end
      first_flg = true
    end
  end
  return used_component_files
end

# pagesディレクトリ配下
def search_page (component_name, target_dir)
  used_page_files = []
  first_flg = true
  tmp_files = {}
  page_dir = target_dir + "/pages"
  Dir.glob('**/*', File::FNM_DOTMATCH, base: page_dir).each do |file|
    file_path = File.join(page_dir, file)
    if File.extname(file) == '.vue'
      File.foreach(file_path, :external_encoding => "UTF-8") do |line|
        if line.include?('<' + component_name) && first_flg
          tmp_files = { file: file, code: [line] }
          first_flg = false
        elsif line.include?('<' + component_name)
          tmp_files[:code] << line
        end
      end
      unless first_flg
        used_page_files << tmp_files
      end
      first_flg = true
    end
  end
  return used_page_files
end

# 結果表示
def show_result(arr, index = 0)
  arr.each do |a|
    puts " " * index + a[:file]
    a[:code].each do |c|
      puts "  " + c
    end
    puts ""
    a[:pearents].each do |p|
      if p.length > 0
        index += 1
        show_result(p, index)
      end
    end
  end
end

########
# 実行 #
########
puts "----------------------------------------------------------------"
puts "target_dir: #{target_dir}"
puts "search_component: #{search_component}"

arr_c = search_component(search_component, target_dir)
arr_p = search_page(search_component, target_dir)


# 結果の出力
puts "----------------------------------------------------------------"

puts "【component】"
show_result(arr_c)

puts "【pages】"
arr_p.each do |f|
  puts f[:file]
  f[:code].each do |c|
    puts "  " + c
  end
  puts ""
end