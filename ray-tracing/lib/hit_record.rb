require_relative "vec3"

class HitRecord
  attr_accessor :p, :normal, :t, :front_face

  def set_face_normal(ray, outward_normal)
    @front_face = Vec3.dot(ray.direction, outward_normal) < 0
    @normal = front_face ? outward_normal : -outward_normal
  end
end