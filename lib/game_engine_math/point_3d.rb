# frozen_string_literal: true

module GameEngineMath
  class Point3D < Vector3D
    def distance(other)
      case other
      when Line3D
        other.distance(self)
      else
        raise ArgumentError, "Unknown object type #{other.class}"
      end
    end
  end
end
