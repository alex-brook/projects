require_relative "hit_record"

class HittableList
  attr_accessor :list

  def initialize(obj=nil)
    @list = []
    @list.push(obj) if obj
  end

  def add(obj)
    @list.push(obj)
  end 

  def hit(ray, ray_tmin, ray_tmax)
    temp_rec = HitRecord.new
    hit_anything = false
    closest_so_far = ray_tmax

    @list.each do |object|
      if object.hit(ray, ray_tmin, closest_so_far, temp_rec)
        hit_anything = true
        closest_so_far = temp_rec.t
        rec = temp_rec
      end
    end

    [hit_anything, temp_rec]
  end
end