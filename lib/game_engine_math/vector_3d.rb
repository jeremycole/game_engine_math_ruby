module GameEngineMath
  class Vector3D
    attr_accessor :x, :y, :z

    def self.from_h(x:'0', y:'0', z:'0')
      Vector3D.new(x, y, z)
    end

    def initialize(x='0', y='0', z='0')
      self.x = Rational(x)
      self.y = Rational(y)
      self.z = Rational(z)
    end

    def to_a
      [x, y, z]
    end

    def to_h
      {x: x, y: y, z: z}
    end

    def ==(o)
      x == o.x && y == o.y && z == o.z
    end

    def send_componentwise(op, xx, yy=nil, zz=nil)
      Vector3D.new(x.send(op, xx), y.send(op, yy || xx), z.send(op, zz || xx))
    end

    def op_other(o, op)
      case o
      when Float, Integer, Rational
        send_componentwise(op, o)
      when Vector3D
        send_componentwise(op, o.x, o.y, o.z)
      else
        raise ArgumentError.new("Unknown type #{o.class} applying #{op} to #{self}")
      end
    end

    def -@
      Vector3D.new(-x, -y, -z)
    end

    def +(o)
      op_other(o, :+)
    end

    def -(o)
      op_other(o, :-)
    end

    def *(o)
      op_other(o, :*)
    end

    def /(o)
      op_other(o, :/)
    end

    def dot(v)
      x * v.x + y * v.y + z * v.z
    end

    def square
      dot(self)
    end

    def magnitude
      Rational(Math.sqrt(square))
    end

    def normalize
      self / magnitude
    end

    def cross(v)
      Vector3D.new(y * v.z - z * v.y,
                   z * v.x - x * v.z,
                   x * v.y - y * v.x)
    end

    def project(v)
      v * (dot(v) / v.square);
    end

    def reject(v)
      self - project(v)
    end
  end
end
