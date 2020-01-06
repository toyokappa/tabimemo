require 'json'
require 'set'
require 'optparse'

# コマンドラインオプションを格納する箱
Config = Struct.new(:task_definition_template) do
  def valid?
    raise "task_definition_template required" unless send(:task_definition_template)
  end
end

$config = Config.new

# メッセージとusage出して死ぬ
def usage_exit(opt, msg = nil)
  puts opt.to_s
  puts "ERROR: #{msg}" if msg
  exit 1
end

# 引数をパースして$configにセットする
def parse_opts!
  opt = OptionParser.new

  opt.on('--task-definition-template PATH') do |v|
    $config.task_definition_template = v
  end

  begin
    opt.parse!(ARGV)
    $config.valid?
  rescue => e
    usage_exit opt, e.message
  end
end

# 文字列contentの中にある${XXX}形式の変数をvarsをキーに取得した環境変数の値で置換する
def expand_env_vars(content, vars)
  vars.each do |env_name|
    content = content.gsub("${#{env_name}}", ENV.fetch(env_name))
  end
  content
end

# 文字列contentsの中から${XXX}型式で書かれているXXXの一意なリストを抽出して返す
def extract_env_vars(content)
  vars = Set.new
  content.scan(/\${(.*?)}/) do |m|
    vars << m[0]
  end
  vars
end

# 文字列contentの中にある環境変数を展開する
def env_expanded(content)
  vars = extract_env_vars(content)
  expand_env_vars(content, vars)
end

# task定義のテンプレートを読んでjsonでhashで返す
def parse_task_definition_template(template)
  content = File.read(template)
  JSON.parse(env_expanded(content))
end

# タスク定義ファイル生成
def main
  parse_opts!
  parsed = parse_task_definition_template($config.task_definition_template)
  puts parsed.to_json
end

main
