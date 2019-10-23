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

    def to_s
      [
        '%1s %6s' % [' ', 'v  '],
        '%1s %6.2f' % ['x', x],
        '%1s %6.2f' % ['y', y],
        '%1s %6.2f' % ['z', z],
      ].join("\n")
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

    def self.rotate_around_axis(axis, angle)
      case axis
      when Symbol
        raise ArgumentError.new("Unknown axis #{axis}") unless [:x, :y, :z].include?(axis)

        axis = Vector3D.from_h({ axis => 1 })
      when Hash
        axis = Vector3D.from_h(axis).normalize
      when Vector3D
        axis = axis.normalize
      else
        raise ArgumentError.new("Unknown axis type #{axis.class}")
      end

      cos = Math.cos(angle)
      sin = Math.sin(angle)
      cos_d = 1.0 - cos

      rx = axis.x * cos_d
      ry = axis.y * cos_d
      rz = axis.z * cos_d

      axay = rx * axis.y
      axaz = rx * axis.z
      ayaz = ry * axis.z

      Matrix3D.from_h({
        a: { x:  cos +  rx * axis.x, y: axay - sin * axis.z, z: axaz + sin * axis.y },
        b: { x: axay + sin * axis.z, y:  cos +  ry * axis.y, z: ayaz - sin * axis.x },
        c: { x: axaz - sin * axis.y, y: ayaz + sin * axis.x, z:  cos +  rz * axis.z }
      })
    end

    def rotate(rotations)
      result = self

      rotations.each do |axis, angle|
        result = Vector3D::rotate_around_axis(axis, angle) * result
      end

      result
    end

    def reflect(v)
      reject(v) - project(v)
    end

    def involute(v)
      project(v) - reject(v)
    end

    def scale(x, y=nil, z=nil)
      Matrix3D::diagonal(x, y, z) * self
    end

    def skew(angle, a, b)
      self + a.normalize * (b.normalize.dot(self)) * Math.tan(angle)
    end

    def zero?
      x.zero? && y.zero? && z.zero?
    end

    X = Vector3D.new(1, 0, 0)
    Y = Vector3D.new(0, 1, 0)
    Z = Vector3D.new(0, 0, 1)
  end
end
