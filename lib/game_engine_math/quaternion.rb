module GameEngineMath
  class Quaternion
    attr_accessor :x, :y, :z, :w

    def self.from_h(x:'0', y:'0', z:'0', w:'0')
      Quaternion.new(x, y, z, w)
    end

    def self.from_vector(v, w=0)
      Quaternion.new(v.x, v.y, v.z, w)
    end

    def self.rotation(axis, angle)
      from_vector(axis * Math.sin(angle / 2.0), Math.cos(angle / 2.0))
    end

    def initialize(x='0', y='0', z='0', w='0')
      self.x = Rational(x)
      self.y = Rational(y)
      self.z = Rational(z)
      self.w = Rational(w)
    end

    def to_s
      [
        '%1s %6s' % [' ', 'q  '],
        '%1s %6.2f' % ['x', x],
        '%1s %6.2f' % ['y', y],
        '%1s %6.2f' % ['z', z],
        '%1s %6.2f' % ['w', w],
      ].join("\n")
    end

    def to_a
      [x, y, z, w]
    end

    def to_h
      {x: x, y: y, z: z, w: w}
    end

    def ==(o)
      x == o.x && y == o.y && z == o.z && w == o.w
    end

    def vector
      Vector3D.new(x, y, z)
    end

    def scalar
      w
    end

    def square
      vector.square + (w * w)
    end

    def magnitude
      Math.sqrt(square)
    end

    def conjugate
      Quaternion.new(-x, -y, -z, w)
    end

    def inverse
      conjugate / square
    end

    def normalize
      self / magnitude
    end

    def +(o)
      case o
      when Integer, Float, Rational
        Quaternion.new(x + o, y + o, z + o, w + o)
      when Quaternion
        Quaternion.new(x + o.x, y + o.y, z + o.z, w + o.w)
      else
        raise ArgumentError.new("Unknown type #{o.class} applying + to #{self}")
      end
    end

    def *(o)
      case o
      when Integer, Float, Rational
        Quaternion.new(x * o, y * o, z * o, w * o)
      when Vector3D
        self * Quaternion.from_vector(o)
      when Quaternion
        Quaternion.new(
          w * o.x + x * o.w + y * o.z - z * o.y,
          w * o.y - x * o.z + y * o.w + z * o.x,
          w * o.z + x * o.y - y * o.x + z * o.w,
          w * o.w - x * o.x - y * o.y - z * o.z,
        )
      else
        raise ArgumentError.new("Unknown type #{o.class} applying * to #{self}")
      end
    end

    def /(o)
      case o
      when Integer, Float, Rational
        Quaternion.new(x / o, y / o, z / o, w / o)
      else
        raise ArgumentError.new("Unknown type #{o.class} applying / to #{self}")
      end
    end

    def transform(v)
      b = vector
      b2 = x * x + y * y + z * z

      v * (w * w - b2) + b * v.dot(b) * 2r + b.cross(v) * (w * 2r)
    end

    def rotate(v)
      self * v * conjugate
    end

    def rotation_matrix
      xx = x * x
      yy = y * y
      zz = z * z
      xy = x * y
      xz = x * z
      yz = y * z
      wx = w * x
      wy = w * y
      wz = w * z

      Matrix3D.new(
        Vector3D.new(1r - 2r * (yy + zz), 2r * (xy - wz), 2r * (xz + wy)),
        Vector3D.new(2r * (xy + wz), 1r - 2r * (xx + zz), 2r * (yz - wx)),
        Vector3D.new(2r * (xz - wy), 2r * (yz + wx), 1r - 2r * (xx + yy))
      )
    end

    def zero?
      x.zero? && y.zero? && z.zero? && w.zero?
    end

    def pure?
      w.zero?
    end
  end
end