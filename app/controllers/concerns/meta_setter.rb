module MetaSetter
  extend ActiveSupport::Concern

  def set_common_meta(key, value)
    # meta, twitter, ogの3箇所を一気に上書きするためのメソッド
    # :title, :description, :imageのみ使用可能
    set_meta_tags key => value,
                  twitter: { key => "#{value}#{' | ' + t('app.title') if key == :title}" },
                  og: { key => value }
  end
end
