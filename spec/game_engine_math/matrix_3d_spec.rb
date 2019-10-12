RSpec.describe GameEngineMath::Matrix3D do
  it 'exists' do
    expect(Matrix3D).to be_an_instance_of Class
    expect(Matrix3D).to eq(GameEngineMath::Matrix3D)
  end

  it 'can instantiate an object' do
    m = Matrix3D.new(
      Vector3D.new(1, 2, 3),
      Vector3D.new(4, 5, 6),
      Vector3D.new(7, 8, 9)
    )

    expect(m.a.x).to eq(1)
    expect(m.a.y).to eq(2)
    expect(m.a.z).to eq(3)
    expect(m.b.x).to eq(4)
    expect(m.b.y).to eq(5)
    expect(m.b.z).to eq(6)
    expect(m.c.x).to eq(7)
    expect(m.c.y).to eq(8)
    expect(m.c.z).to eq(9)
  end

  it 'can instantiate an object using from_h' do
    m = Matrix3D.from_h({
      a: { x: 1, y: 2, z: 3 },
      b: { x: 4, y: 5, z: 6 },
      c: { x: 7, y: 8, z: 9 }
    })

    expect(m.a.x).to eq(1)
    expect(m.a.y).to eq(2)
    expect(m.a.z).to eq(3)
    expect(m.b.x).to eq(4)
    expect(m.b.y).to eq(5)
    expect(m.b.z).to eq(6)
    expect(m.c.x).to eq(7)
    expect(m.c.y).to eq(8)
    expect(m.c.z).to eq(9)
  end

  it 'can perform vector multiplication' do
    m = Matrix3D::SAMPLE_A
    v = Vector3D.new(10, 11, 12)
    r = m * v

    expect(r).to eq(Vector3D.from_h(x: 138, y: 99, z: 204))
  end

  it 'can perform matrix multiplication' do
    expect(Matrix3D::SAMPLE_A * Matrix3D::SAMPLE_B).to eq(Matrix3D.from_h({
      a: { x: 30, y: 18, z: 42},
      b: { x: 18, y: 18, z: 30},
      c: { x: 27, y: 21, z: 39},
    }))
  end

  it 'can calculate the determinant' do
    expect(Matrix3D::SAMPLE_A.determinant).to eq(-36r)
  end

  it 'can invert a matrix' do
    expect(Matrix3D::SAMPLE_A.inverse).to eq(Matrix3D.from_h({
      a: { x: -11/12r, y: 1/3r,  z: 1/12r },
      b: { x: -1/6r,   y: 1/3r,  z: -1/6r },
      c: { x: 3/4r,    y: -1/3r, z: 1/12r },
    }))
  end

  it 'expresses the determinant of the identity' do
    expect(Matrix3D::IDENTITY.determinant).to eq(1)
  end

  it 'expresses the product rule for the determinant' do
    expect((Matrix3D::SAMPLE_A * Matrix3D::SAMPLE_B).determinant)
      .to be_close_to(Matrix3D::SAMPLE_A.determinant * Matrix3D::SAMPLE_B.determinant)
  end

  it 'expresses the determinant of an inverse matrix' do
    expect(Matrix3D::SAMPLE_A.inverse.determinant)
      .to eq(1r / Matrix3D::SAMPLE_A.determinant)
  end

  it 'expresses scalar factorization for the determinant' do
    expect((Matrix3D::SAMPLE_A * 7r).determinant)
      .to be_close_to((7r ** 3) * Matrix3D::SAMPLE_A.determinant)
    expect((Matrix3D::SAMPLE_B * 2r).determinant)
      .to be_close_to((2r ** 3) * Matrix3D::SAMPLE_B.determinant)
  end

  it 'expresses transpose symmetry for the determinant' do
    expect(Matrix3D::SAMPLE_A.transpose.determinant)
      .to be_close_to(Matrix3D::SAMPLE_A.determinant)
  end
end
