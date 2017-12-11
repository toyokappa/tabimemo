class ImagePreviewInput < SimpleForm::Inputs::FileInput
  def input(wrapper_options)
    # :preview_version is a custom attribute from :input_html hash, so you can pick custom sizes
    version = input_html_options.delete(:preview_version)
    out = "" # the output string we're going to build
    # check if there's an uploaded file (eg: edit mode or form not saved)
    if object.send("#{attribute_name}?")
      # append preview image to output
      if object.send(attribute_name).instance_of?(Array)
        object.send(attribute_name).each do |obj|
          url = template.image_tag(obj.tap {|o| break o.send(version) if version}.send('url'))
          out << "<div>#{url}</div>"
        end
      else
        url = template.image_tag(object.send(attribute_name).tap {|o| break o.send(version) if version}.send('url'))
        out << "<div>#{url}</div>"
      end
    end
    # allow multiple submissions without losing the tmp version
    out << @builder.hidden_field("#{attribute_name}_cache").html_safe
    # append file input. it will work accordingly with your simple_form wrappers
    (out << @builder.file_field(attribute_name, input_html_options)).html_safe
  end
end
