require_relative "describe"
require_relative "vec3"

class Ray
  include Describe
  using NumericVec3

  attr_reader :origin, :direction

  def initialize(origin, direction)
    @origin = origin
    @direction = direction
  end

  describe "#at" do
    ray = Ray.new(
      Vec3.new(0, 0, 0),
      Vec3.new(1, 1, 1),
    )

    start = ray.at(0)
    expect([start.x, start.y, start.z]).to eq([0, 0, 0])
    one = ray.at(1)
    expect([one.x, one.y, one.z]).to eq([1, 1, 1])
    ten = ray.at(10)
    expect([ten.x, ten.y, ten.z]).to eq([10, 10, 10])
  end

  def at(t)
    origin + (t * direction)
  end
end