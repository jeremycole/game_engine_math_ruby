# frozen_string_literal: true

module GameEngineMath
  class Matrix3D
    attr_accessor :a, :b, :c

    def self.from_h(a: Vector3D.new, b: Vector3D.new, c: Vector3D.new)
      a = Vector3D.from_h(a) if a.is_a?(Hash)
      b = Vector3D.from_h(b) if b.is_a?(Hash)
      c = Vector3D.from_h(c) if c.is_a?(Hash)

      Matrix3D.new(a, b, c)
    end

    def self.fill(i)
      Matrix3D.new(
        Vector3D.new(i, i, i),
        Vector3D.new(i, i, i),
        Vector3D.new(i, i, i)
      )
    end

    def self.diagonal(i, j = nil, k = nil)
      Matrix3D.new(
        Vector3D.new(i, 0, 0),
        Vector3D.new(0, j || i, 0),
        Vector3D.new(0, 0, k || i)
      )
    end

    def initialize(a = Vector3D.new, b = Vector3D.new, c = Vector3D.new)
      self.a = a
      self.b = b
      self.c = c
    end

    def to_s
      [
        '%1s %6s %6s %6s' % [' ', 'a  ', 'b  ', 'c  '],
        '%1s %6.2f %6.2f %6.2f' % ['x', a.x, b.x, c.x],
        '%1s %6.2f %6.2f %6.2f' % ['y', a.y, b.y, c.y],
        '%1s %6.2f %6.2f %6.2f' % ['z', a.z, b.z, c.z],
      ].join("\n")
    end

    def to_h
      { a: a.to_h, b: b.to_h, c: c.to_h }
    end

    def ==(o)
      a == o.a && b == o.b && c == o.c
    end

    def m(i, j)
      [
        [a.x, a.y, a.z],
        [b.x, b.y, b.z],
        [c.x, c.y, c.z],
      ][j][i]
    end

    def row(r)
      Vector3D.new(a.send(r), b.send(r), c.send(r))
    end

    def x
      @x ||= row(:x)
    end

    def y
      @y ||= row(:y)
    end

    def z
      @z ||= row(:z)
    end

    def yz
      @yz ||= y.cross(z)
    end

    def zx
      @zx ||= z.cross(x)
    end

    def xy
      @xy ||= x.cross(y)
    end

    def +(o)
      case o
      when Matrix3D
        Matrix3D.new(
          Vector3D.new(a.x + o.a.x, a.y + o.a.y, a.z + o.a.z),
          Vector3D.new(b.x + o.b.x, b.y + o.b.y, b.z + o.b.z),
          Vector3D.new(c.x + o.c.x, c.y + o.c.y, c.z + o.c.z)
        )
      else
        raise ArgumentError, "Unknown type #{o.class} applying + to #{self}"
      end
    end

    def -(o)
      case o
      when Matrix3D
        Matrix3D.new(
          Vector3D.new(a.x - o.a.x, a.y - o.a.y, a.z - o.a.z),
          Vector3D.new(b.x - o.b.x, b.y - o.b.y, b.z - o.b.z),
          Vector3D.new(c.x - o.c.x, c.y - o.c.y, c.z - o.c.z)
        )
      else
        raise ArgumentError, "Unknown type #{o.class} applying - to #{self}"
      end
    end

    def *(o)
      case o
      when Float, Integer, Rational
        self * Matrix3D.diagonal(o)
      when Vector3D
        Vector3D.new(x.dot(o), y.dot(o), z.dot(o))
      when Matrix3D
        Matrix3D.new(
          Vector3D.new(x.dot(o.a), y.dot(o.a), z.dot(o.a)),
          Vector3D.new(x.dot(o.b), y.dot(o.b), z.dot(o.b)),
          Vector3D.new(x.dot(o.c), y.dot(o.c), z.dot(o.c))
        )
      else
        raise ArgumentError, "Unknown type #{o.class} applying * to #{self}"
      end
    end

    def determinant
      i = (a.x * (b.y * c.z - c.y * b.z))
      j = (b.x * (a.y * c.z - c.y * a.z))
      k = (c.x * (a.y * b.z - b.y * a.z))

      i - j + k
    end

    def invertible?
      determinant != 0r
    end

    def inverse
      return nil unless invertible?

      id = 1r / determinant

      Matrix3D.from_h(
        a: { x: yz.x * id, y: yz.y * id, z: yz.z * id },
        b: { x: zx.x * id, y: zx.y * id, z: zx.z * id },
        c: { x: xy.x * id, y: xy.y * id, z: xy.z * id }
      )
    end

    def transpose
      Matrix3D.new(x, y, z)
    end

    def trace
      a.x + b.y + c.z
    end

    def zero?
      a.zero? && b.zero? && c.zero?
    end

    def diagonal?
      a.y.zero? && a.z.zero? && b.x.zero? && b.z.zero? && c.x.zero? && x.y.zero?
    end

    def symmetric?
      a.y == b.x && a.z == c.x && b.z == c.y
    end

    def skew_symmetric?
      a.y == -b.x && a.z == -c.x && b.z == -c.y
    end

    ZERO = Matrix3D.new

    IDENTITY = diagonal(1)

    SAMPLE_A = Matrix3D.from_h(
      a: { x: 1, y: 2, z: 3 },
      b: { x: 4, y: 5, z: 6 },
      c: { x: 7, y: 2, z: 9 }
    )

    SAMPLE_B = Matrix3D.from_h(
      a: { x: 1, y: 2, z: 3 },
      b: { x: 3, y: 2, z: 1 },
      c: { x: 1, y: 3, z: 2 }
    )

    # Symmetric.
    SAMPLE_C = Matrix3D.from_h(
      a: { x: 1, y: 3, z: 1 },
      b: { x: 3, y: 2, z: 3 },
      c: { x: 1, y: 3, z: 2 }
    )

    # Skew symmetric.
    SAMPLE_D = Matrix3D.from_h(
      a: { x: 1, y: -3, z: 1 },
      b: { x: 3,  y: 2,  z: 5 },
      c: { x: -1, y: -5, z: 2 }
    )
  end
end
