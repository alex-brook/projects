module MathHelpers
  refine Float do
    def self.to_rad(degrees)
      degrees * PI / 180.0
    end
  end
end