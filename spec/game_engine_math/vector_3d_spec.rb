RSpec.describe GameEngineMath::Vector3D do
  it 'exists' do
    expect(Vector3D).to be_an_instance_of Class
    expect(Vector3D).to eq(GameEngineMath::Vector3D)
  end

  it 'can instantiate an object' do
    v = Vector3D.new(1.0, 2.0, 3.0)

    expect(v.x).to be_close_to(1.0)
    expect(v.y).to be_close_to(2.0)
    expect(v.z).to be_close_to(3.0)
  end

  it 'can instantiate an object using from_h' do
    v = Vector3D.new(1.0, 2.0, 3.0)

    expect(v.x).to be_close_to(1.0)
    expect(v.y).to be_close_to(2.0)
    expect(v.z).to be_close_to(3.0)
  end

  it 'can perform scalar multiplication' do
    v = Vector3D.new(1.0, 2.0, 3.0)
    v *= 2

    expect(v).to eq_a_Vector3D(Vector3D.from_h(x: 2.0, y: 4.0, z: 6.0))
  end

  it 'can perform scalar division' do
    v = Vector3D.new(1.0, 2.0, 3.0)
    v /= 2

    expect(v).to eq_a_Vector3D(Vector3D.from_h(x: 0.5, y: 1.0, z: 1.5))
  end

  it 'can perform vector addition' do
    a = Vector3D.new(1.0, 2.0, 3.0)
    b = Vector3D.new(2.0, 3.0, 4.0)
    r = a + b

    expect(r).to eq_a_Vector3D(Vector3D.from_h(x: 3, y: 5, z: 7))
  end

  it 'can perform vector subtraction' do
    a = Vector3D.new(1.0, 2.0, 3.0)
    b = Vector3D.new(1.0, 1.0, 1.0)
    r = a - b

    expect(r).to eq_a_Vector3D(Vector3D.from_h(x: 0, y: 1, z: 2))
  end

  it 'can perform vector multiplication' do
    a = Vector3D.new(1.0, 2.0, 3.0)
    b = Vector3D.new(2.0, 3.0, 4.0)
    r = a * b

    expect(r).to eq_a_Vector3D(Vector3D.from_h(x: 2, y: 6, z: 12))
  end

  it 'can perform vector division' do
    a = Vector3D.new(1.0, 2.0, 3.0)
    b = Vector3D.new(2.0, 3.0, 8.0)
    r = a / b

    expect(r).to eq_a_Vector3D(Vector3D.from_h(x: 1.0/2.0, y: 2.0/3.0, z: 3.0/8.0))
  end

  it 'can calculate magnitude' do
    v = Vector3D.new(1.0, 2.0, 3.0)

    expect(v.magnitude).to be_close_to(3.74165738)
  end

  it 'can normalize a vector' do
    v = Vector3D.new(1.0, 2.0, 3.0)

    expect(v.normalize).to eq_a_Vector3D(Vector3D.from_h({
      x: 0.26726124,
      y: 0.53452248,
      z: 0.80178373
    }))
  end

  it 'can calculate dot product of orthogonal vectors' do
    a = Vector3D.new(0, 1, 0)
    b = Vector3D.new(1, 0, 0)

    expect(a.dot(b)).to eq(0.0)
    expect(b.dot(a)).to eq(0.0)
  end

  it 'can calculate dot product of parallel vectors' do
    a = Vector3D.new(3, 0, 0)
    b = Vector3D.new(-5, 0, 0)

    expect(a.dot(a)).to be_close_to(9.0)
    expect(b.dot(b)).to be_close_to(25.0)
    expect(a.dot(b)).to be_close_to(-15.0)
  end

  it 'expresses anticommutativity' do
    a = Vector3D.new(1, 2, 3)
    b = Vector3D.new(4, 5, 6)

    expect(a.cross(b)).to eq_a_Vector3D(-b.cross((a)))
  end

  it 'expresses distributive law' do
    a = Vector3D.new(1, 2, 3)
    b = Vector3D.new(4, 5, 6)
    c = Vector3D.new(7, 8, 9)

    expect(a.cross(b + c)).to eq_a_Vector3D(a.cross(b) + a.cross(c))
  end

  it 'expresses distributive law' do
    a = Vector3D.new(1, 2, 3)
    b = Vector3D.new(4, 5, 6)
    t = 7.0

    expect((a * t).cross(b)).to eq_a_Vector3D(a.cross(b * t))
    expect(a.cross(b * t)).to eq_a_Vector3D(a.cross(b) * t)
  end

  it 'calculates triple product correctly' do
    a = Vector3D.new(1, 2, 3)
    b = Vector3D.new(4, 5, 6)
    c = Vector3D.new(7, 8, 9)

    expect(a.cross(b.cross(c))).to eq_a_Vector3D(b * a.dot(c) - c * a.dot(b))
  end

  it 'projects correctly' do
    a = Vector3D.new(0, 1, 0)
    b = Vector3D.new(1, 1, 0)

    p = a.project(b)
    r = a.reject(b)

    expect(p).to eq_a_Vector3D(Vector3D.from_h(x: 0.5, y: 0.5, z: 0.0))
    expect(r).to eq_a_Vector3D(Vector3D.from_h(x: -0.5, y: 0.5, z: 0.0))
    expect(p.magnitude).to be_close_to(Math.sin((Math::PI / 180) * 45))
    expect(r.magnitude).to be_close_to(Math.sin((Math::PI / 180) * 45))
  end
end