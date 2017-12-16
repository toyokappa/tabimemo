module ApplicationHelper
  def new_spot_field(f)
    new_object = f.object.spots.new
    id = "new_spot"
    fields = f.fields_for(:spots, new_object, child_index: id) do |builder|
      render '/users/plans/spot_fields', f: builder
    end
    { fields: fields.gsub("\n", ""), id: id }
  end
end
