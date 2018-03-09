Ransack.configure do |config|
  config.add_predicate :all, arel_predicate: :matches_all, formatter: proc { |v| v.split(/[\s"　"]/).map { |t| "%#{t}%" } }
end
