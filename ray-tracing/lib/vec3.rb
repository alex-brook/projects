require "chunky_png"
require_relative "describe"

class Vec3
  include Describe 

  def initialize(e0=0, e1=1, e2=2)
    @e = [e0, e1, e2].map!(&:to_f)
  end
  def [](i)= @e[i]
  def x()= self.[](0)
  def y()= self.[](1)
  def z()= self.[](2)

  describe "#-@" do
    vec = -Vec3.new(1, 2, 3)
    expect([vec.x, vec.y, vec.z]).to eq([-1, -2, -3])
  end

  def -@
    Vec3.new(-@e[0], -@e[1], -@e[2])
  end

  describe "#+" do
    vec_a = Vec3.new(1, 2, 3)
    vec_b = Vec3.new(4, 5, 6)
    vec = vec_a + vec_b
    expect([vec.x, vec.y, vec.z]).to eq([5, 7, 9])
  end 

  def +(obj)
    case obj
    in Vec3
      Vec3.new(
        x + obj.x,
        y + obj.y,
        z + obj.z,
      )
    else
      raise NotImplementedError.new
    end
  end

  describe "#-" do
    vec_a = Vec3.new(1, 2, 3)
    vec_b = Vec3.new(4, 5, 6)
    vec = vec_a - vec_b
    expect([vec.x, vec.y, vec.z]).to eq([-3, -3, -3])
  end

  def -(obj)
    case obj
    in Vec3
      Vec3.new(
        x - obj.x,
        y - obj.y,
        z - obj.z,
      )
    else
      raise NotImplementedError.new
    end
  end

  describe "#*" do
    vec_a = Vec3.new(1, 2, 3)
    vec = vec_a * 5.0
    expect([vec.x, vec.y, vec.z]).to eq([5, 10, 15])
  end 

  def *(obj)
    case obj
    in Numeric
      Vec3.new(
        x * obj,
        y * obj,
        z * obj,
      )
    else
      raise NotImplementedError.new
    end
  end

  describe "#/" do
    vec = Vec3.new(1, 2, 3)
    vec = vec / 3
    expect(vec.x).to be_within(0.01).of(0.33)
    expect(vec.y).to be_within(0.01).of(0.66)
    expect(vec.z).to eq(1)
  end

  def /(obj)
    case obj
    in Numeric
      self.*(1.fdiv(obj))
    else
      raise NotImplementedError.new
    end
  end

  describe "#length" do
    vec = Vec3.new(1, 2, 3)
    expect(vec.length).to be_within(0.01).of(3.74)
  end

  def length
    Math.sqrt(length_squared)
  end

  def length_squared
    @e.sum { _1 ** 2 }
  end

  describe "#color" do
    expect(Vec3.new(0, 0, 0).color).to eq(ChunkyPNG::Color("black"))
    expect(Vec3.new(1, 1, 1).color).to eq(ChunkyPNG::Color("white"))
    expect(Vec3.new(1, 0, 0).color).to eq(ChunkyPNG::Color("red"))
  end

  def color
    r, g, b = @e.map { (255.0 * _1).to_i }
    ChunkyPNG::Color.rgb(r, g, b)
  end

  describe ":dot" do
    vec_a = Vec3.new(1, 2, 3)
    vec_b = Vec3.new(4, 5, 6)
    dot = Vec3.dot(vec_a, vec_b)
    expect(dot).to eq(32)
  end 

  def self.dot(u, v)
    (u[0] * v[0]) +
    (u[1] * v[1]) +
    (u[2] * v[2])
  end

  describe ":cross" do
    vec_a = Vec3.new(1, 2, 3)
    vec_b = Vec3.new(4, 5, 6)
    cross = Vec3.cross(vec_a, vec_b)
    expect([cross.x, cross.y, cross.z]).to eq([-3, 6, -3])
  end

  def self.cross(u, v)
    Vec3.new(
      (u[1] * v[2]) - (u[2] * v[1]),
      (u[2] * v[0]) - (u[0] * v[2]),
      (u[0] * v[1]) - (u[1] * v[0])
    )
  end

  describe ":unit_vector" do
    vec = Vec3.new(4, 5, 6)
    vec = Vec3.unit_vector(vec)
    expect(vec.x).to be_within(0.01).of(0.45)
    expect(vec.y).to be_within(0.01).of(0.56)
    expect(vec.z).to be_within(0.01).of(0.68)
  end

  def self.unit_vector(v)
    v / v.length
  end 
end

Point3 = Vec3
Color = Vec3

module NumericVec3
  [Float, Integer].each do |klass|
    refine klass do
      def *(obj)
        case obj
        in Vec3
          obj * self
        else
          super
        end
      end

      def -(obj)
        case obj
        in Vec3
          obj * self
        else
          super
        end
      end
    end
  end
end