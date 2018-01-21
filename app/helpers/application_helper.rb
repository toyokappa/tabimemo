module ApplicationHelper
  def new_spot_field(f)
    new_object = f.object.spots.new
    id = "new_spot"
    plan_id = f.object.id
    fields = f.fields_for(:spots, new_object, child_index: id) do |builder|
      render "/users/plans/spot_fields", f: builder
    end
    { fields: fields.gsub("\n", ""), id: id, plan_id: plan_id }
  end

  def new_photo_field(f)
    new_object = f.object.photos.new
    id = "new_photo"
    fields = f.fields_for(:photos, new_object, child_index: id) do |builder|
      render "/users/plans/photo_fields", f: builder
    end
    { fields: fields.gsub("\n", ""), id: id }
  end
end
