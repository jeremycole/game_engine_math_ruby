RSpec.describe GameEngineMath::Vector3D do
  it 'exists' do
    expect(Vector3D).to be_an_instance_of Class
    expect(Vector3D).to eq(GameEngineMath::Vector3D)
  end

  it 'can instantiate an object' do
    v = Vector3D.new(1, 2, 3)

    expect(v.x).to eq(1)
    expect(v.y).to eq(2)
    expect(v.z).to eq(3)
  end

  it 'can instantiate an object using from_h' do
    v = Vector3D.new(1, 2, 3)

    expect(v.x).to eq(1)
    expect(v.y).to eq(2)
    expect(v.z).to eq(3)
  end

  it 'can perform scalar multiplication' do
    v = Vector3D.new(1, 2, 3)
    v *= 2

    expect(v).to eq(Vector3D.from_h(x: 2, y: 4, z: 6))
  end

  it 'can perform scalar division' do
    v = Vector3D.new(1, 2, 3)
    v /= 2

    expect(v).to eq(Vector3D.from_h(x: 1/2r, y: 1r, z: 3/2r))
  end

  it 'can perform vector addition' do
    a = Vector3D.new(1, 2, 3)
    b = Vector3D.new(2, 3, 4)
    r = a + b

    expect(r).to eq(Vector3D.from_h(x: 3, y: 5, z: 7))
  end

  it 'can perform vector subtraction' do
    a = Vector3D.new(1, 2, 3)
    b = Vector3D.new(1, 1, 1)
    r = a - b

    expect(r).to eq(Vector3D.from_h(x: 0, y: 1, z: 2))
  end

  it 'can perform vector multiplication' do
    a = Vector3D.new(1, 2, 3)
    b = Vector3D.new(2, 3, 4)
    r = a * b

    expect(r).to eq(Vector3D.from_h(x: 2, y: 6, z: 12))
  end

  it 'can perform vector division' do
    a = Vector3D.new(1, 2, 3)
    b = Vector3D.new(2, 3, 8)
    r = a / b

    expect(r).to eq(Vector3D.from_h(x: 1/2r, y: 2/3r, z: 3/8r))
  end

  it 'can calculate magnitude' do
    v = Vector3D.new(1, 2, 3)

    expect(v.magnitude).to be_close_to(3.74165738)
  end

  it 'can normalize a vector' do
    v = Vector3D.new(1, 2, 3)

    expect(v.normalize).to eq_a_Vector3D(Vector3D.from_h({
      x: 0.26726124,
      y: 0.53452248,
      z: 0.80178373
    }))
  end

  it 'can calculate dot product of orthogonal vectors' do
    a = Vector3D.new(0, 1, 0)
    b = Vector3D.new(1, 0, 0)

    expect(a.dot(b)).to eq(0)
    expect(b.dot(a)).to eq(0)
  end

  it 'can calculate dot product of parallel vectors' do
    a = Vector3D.new(3, 0, 0)
    b = Vector3D.new(-5, 0, 0)

    expect(a.dot(a)).to be_close_to(9)
    expect(b.dot(b)).to be_close_to(25)
    expect(a.dot(b)).to be_close_to(-15)
  end

  it 'expresses anticommutativity' do
    a = Vector3D.new(1, 2, 3)
    b = Vector3D.new(4, 5, 6)

    expect(a.cross(b)).to eq(-b.cross((a)))
  end

  it 'expresses distributive law' do
    a = Vector3D.new(1, 2, 3)
    b = Vector3D.new(4, 5, 6)
    c = Vector3D.new(7, 8, 9)

    expect(a.cross(b + c)).to eq(a.cross(b) + a.cross(c))
  end

  it 'expresses distributive law' do
    a = Vector3D.new(1, 2, 3)
    b = Vector3D.new(4, 5, 6)
    t = 7

    expect((a * t).cross(b)).to eq(a.cross(b * t))
    expect(a.cross(b * t)).to eq(a.cross(b) * t)
  end

  it 'calculates triple product correctly' do
    a = Vector3D.new(1, 2, 3)
    b = Vector3D.new(4, 5, 6)
    c = Vector3D.new(7, 8, 9)

    expect(a.cross(b.cross(c))).to eq(b * a.dot(c) - c * a.dot(b))
  end

  it 'projects correctly' do
    a = Vector3D.new(0, 1, 0)
    b = Vector3D.new(1, 1, 0)

    p = a.project(b)
    r = a.reject(b)

    expect(p).to eq(Vector3D.from_h(x: 1/2r, y: 1/2r, z: 0))
    expect(r).to eq(Vector3D.from_h(x: -1/2r, y: 1/2r, z: 0.0))

    expect(p.magnitude).to be_close_to(Math.sin((Math::PI / 180) * 45))
    expect(r.magnitude).to be_close_to(Math.sin((Math::PI / 180) * 45))
  end

  it 'expresses the Jacobi identity' do
    a = Vector3D.new(1, 2, 3)
    b = Vector3D.new(4, 5, 6)
    c = Vector3D.new(7, 8, 9)

    r = a.cross(b.cross(c)) + b.cross(c.cross(a)) + c.cross(a.cross(b))

    expect(r.zero?).to be true
  end

  it 'can calculate the rejection via cross product' do
    a = Vector3D.new(1, 2, 3)
    b = Vector3D.new(4, 5, 6)

    expect(b.cross(a.cross(b)) / b.square).to eq a.reject(b)
  end

  it 'can rotate a vector back to itself' do
    a = Vector3D.new(1, 2, 3)

    expect(a.rotate(x: Math::PI*2, y: Math::PI*2, z: Math::PI*2)).to eq_a_Vector3D(a)
  end

  it 'can rotate a vector about an arbitrary axis' do
    a = Vector3D.new(1, 1, 1)

    expect(a.rotate(Vector3D.new(1, 1, 0) => Math::PI))
      .to eq_a_Vector3D(Vector3D.new(1, 1, -1))
  end
end
