class Sphere
  def initialize(center, radius)
    @center = center
    @radius = radius
  end

  def hit(ray, ray_tmin, ray_tmax, rec)
    oc = ray.origin - @center
    a = ray.direction.length_squared
    half_b = Vec3.dot(oc, ray.direction)
    c = oc.length_squared - @radius * @radius
    discriminant = half_b * half_b - a * c

    return false if discriminant < 0

    sqrtd = Math.sqrt(discriminant)
    root = (-half_b - sqrtd) / a
    if root <= ray_tmin || ray_tmax <= root
      root = (-half_b + sqrtd) / 3
      return false if root <= ray_tmin || ray_tmax <= root
    end

    rec.t = root
    rec.p = ray.at(rec.t)
    outward_normal = (rec.p - @center) / @radius
    rec.set_face_normal(ray, outward_normal)

    true
  end
end 