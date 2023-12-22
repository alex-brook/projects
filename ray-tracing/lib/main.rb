require "chunky_png"
require_relative "vec3"
require_relative "ray"
require_relative "hittable_list"
require_relative "sphere"

class Main
  using NumericVec3

  def self.ray_color(ray, world)
    hit_anything, temp_rec = world.hit(ray, 0, Float::INFINITY)
    if hit_anything
      return 0.5 * (temp_rec.normal + Color.new(1, 1, 1))
    end

    unit_direction = Vec3.unit_vector(ray.direction)
    a = 0.5 * (unit_direction.y + 1.0)
    (1.0 - a) * Color.new(1.0, 1.0, 1.0) + a * Color.new(0.5, 0.7, 1.0)
  end

  def self.main
    aspect_ratio = 16.0 / 9.0
    image_width = 400
    image_height = [image_width.fdiv(aspect_ratio), 1].max.to_i

    # world
    world = HittableList.new
    world.add(Sphere.new(Point3.new(0, 0, -1), 0.5))
    world.add(Sphere.new(Point3.new(0, -100.5, -1), 100))

    # camera
    focal_length = 1.0
    viewport_height = 2.0
    viewport_width = viewport_height * (image_width.fdiv(image_height))
    camera_center = Point3.new(0, 0, 0)

    # vectors for moving around the image
    viewport_u = Vec3.new(viewport_width, 0, 0)
    viewport_v = Vec3.new(0, -viewport_height, 0)

    # vectors for moving between pixels
    pixel_delta_u = viewport_u / image_width
    pixel_delta_v = viewport_v / image_height

    # origin pixel location
    viewport_upper_left = camera_center -
      Vec3.new(0, 0, focal_length) - (viewport_u / 2) - (viewport_v / 2)

    pixel100_loc = viewport_upper_left + 0.5 * (pixel_delta_u + pixel_delta_v)

    png = ChunkyPNG::Image.new(image_width, image_height)

    image_height.times do |j|
      puts "Scanlines remaining: #{image_height - j}"
      image_width.times do |i|
        pixel_center = pixel100_loc + (i * pixel_delta_u) + (j * pixel_delta_v)
        ray_direction = pixel_center - camera_center

        ray = Ray.new(camera_center, ray_direction)
        pixel_color = ray_color(ray, world).color

        png[i, j] = pixel_color
      end
    end

    png.save("render.png", interlace: true)

  end
end