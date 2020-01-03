# コマンドラインオプションを格納する箱
Config = Struct.new(:task_definition_template, :env_file, :secrets_file) do
  def valid?
    %i[task_definition_template env_file secrets_file].each do |opt|
      raise "#{opt} required" unless send(opt)
    end
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
  opt.on('--env_file PATH') do |v|
    $config.env_file = v
  end
  opt.on('--secrets-file PATH') do |v|
    $config.secrets_file = v
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

# secretsの情報が入ったファイルを読んでhashで返す
def parse_secrets_file(file)
  YAML.load(File.read(file))['secrets'].each_with_object({}) do |hash, obj|
    obj[hash['value_from']] = hash['name']
  end
end

# 環境変数(XXX=YYY)型式のファイルからhashにして返す
def parse_env_file(file)
  File.readlines(file).map(&:chomp).each_with_object({}) do |line, obj|
    next if /^\s*#/ =~ line
    if /^([^=]+)=(.*)$/ =~ line
      key = Regexp.last_match(1)
      value = Regexp.last_match(2)
      obj[key] = value
    end
  end
end

# hashから、タスク定義のenvironmentsの書式に変換する
def hash_to_task_definition_environments(hash)
  hash.map do |k, v|
    {
      name: env_expanded(k),
      value: env_expanded(v)
    }
  end
end

# hashから、タスク定義のsecretsの書式に変換する
def hash_to_task_definition_secrets(hash)
  hash.map do |k, v|
    {
      valueFrom: env_expanded(k),
      name: env_expanded(v)
    }
  end
end

# タスク定義ファイル生成
def main
  parse_opts!

  # task定義のテンプレートを読み込んで
  # secrets.ymlから、task定義のsecretを
  # env_fileから、task定義のenvironmentを
  # 設定した上で、${XXX}形式になっている箇所をこのスクリプト実行時に定義されている環境変数で置換する
  secrets = parse_secrets_file($config.secrets_file)
  environments = parse_env_file($config.env_file)

  parsed = parse_task_definition_template($config.task_definition_template)

  parsed['containerDefinitions'].each do |cd|
    cd['environment'] = hash_to_task_definition_environments(environments)
    cd['secrets'] = hash_to_task_definition_secrets(secrets)
  end

  puts parsed.to_json
end

main
