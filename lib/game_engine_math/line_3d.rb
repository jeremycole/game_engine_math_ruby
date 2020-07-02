# frozen_string_literal: true

module GameEngineMath
  class Line3D
    attr_accessor :p, :v

    def initialize(p, v)
      @p = p
      @v = v
    end

    def self.distance_from_point(line, point)
      a = (point - line.p).cross(line.v)
      Math.sqrt(a.dot(a) / line.v.dot(line.v))
    end

    def self.distance_between_lines(l1, l2)
      dp = l2.p - l1.p
      v12 = l1.v.dot(l2.v)
      v22 = l2.v.dot(l2.v)
      v1v2 = l1.v.dot(l2.v)

      det = v1v2 * v1v2 - v12 * v22

      if det.abs.zero?
        a = dp.cross(l1.v)
        return Math.sqrt(a.dot(a) / v12)
      end

      det = 1.0 / det

      dpv1 = dp.dot(l1.v)
      dpv2 = dp.dot(l2.v)
      t1 = (v1v2 * dpv2 - v22 * dpv1) * det
      t2 = (v12 * dpv2 - v1v2 * dpv1) * det

      (dp + l2.v * t2 - l1.v * t1).magnitude
    end

    def distance(other)
      case other
      when Point3D
        Line3D.distance_from_point(self, other)
      when Line3D
        Line3D.distance_between_lines(self, other)
      else
        raise ArgumentError, "Unknown object type #{other.class}"
      end
    end
  end
end
