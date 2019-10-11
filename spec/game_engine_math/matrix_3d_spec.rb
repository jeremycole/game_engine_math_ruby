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

    expect(m.a.x).to be_close_to(1.0)
    expect(m.a.y).to be_close_to(2.0)
    expect(m.a.z).to be_close_to(3.0)
    expect(m.b.x).to be_close_to(4.0)
    expect(m.b.y).to be_close_to(5.0)
    expect(m.b.z).to be_close_to(6.0)
    expect(m.c.x).to be_close_to(7.0)
    expect(m.c.y).to be_close_to(8.0)
    expect(m.c.z).to be_close_to(9.0)
  end

  it 'can instantiate an object using from_h' do
    m = Matrix3D.from_h({
      a: { x: 1, y: 2, z: 3 },
      b: { x: 4, y: 5, z: 6 },
      c: { x: 7, y: 8, z: 9 }
    })

    expect(m.a.x).to be_close_to(1.0)
    expect(m.a.y).to be_close_to(2.0)
    expect(m.a.z).to be_close_to(3.0)
    expect(m.b.x).to be_close_to(4.0)
    expect(m.b.y).to be_close_to(5.0)
    expect(m.b.z).to be_close_to(6.0)
    expect(m.c.x).to be_close_to(7.0)
    expect(m.c.y).to be_close_to(8.0)
    expect(m.c.z).to be_close_to(9.0)
  end

  it 'can perform vector multiplication' do
    m = Matrix3D::SAMPLE_A
    v = Vector3D.new(10, 11, 12)
    r = m * v

    expect(r).to eq_a_Vector3D(Vector3D.from_h(x: 138, y: 99, z: 204))
  end

  it 'can perform matrix multiplication' do
    expect(Matrix3D::SAMPLE_A * Matrix3D::SAMPLE_B).to eq_a_Matrix3D(Matrix3D.from_h({
      a: { x: 30, y: 18, z: 42},
      b: { x: 18, y: 18, z: 30},
      c: { x: 27, y: 21, z: 39},
    }))
  end

  it 'can calculate the determinant' do
    expect(Matrix3D::SAMPLE_A.determinant).to be_close_to(-36)
  end

  it 'can invert a matrix' do
    expect(Matrix3D::SAMPLE_A.inverse).to eq_a_Matrix3D(Matrix3D.from_h({
      a: { x: -11.0 / 12.0, y:  1.0 / 3.0, z:  1.0 / 12.0 },
      b: { x:  -1.0 /  6.0, y:  1.0 / 3.0, z: -1.0 /  6.0 },
      c: { x:   3.0 /  4.0, y: -1.0 / 3.0, z:  1.0 / 12.0 },
    }))
  end

  it 'expresses the determinant of the identity' do
    expect(Matrix3D::IDENTITY.determinant).to be_close_to(1)
  end

  it 'expresses the product rule for the determinant' do
    expect((Matrix3D::SAMPLE_A * Matrix3D::SAMPLE_B).determinant)
      .to be_close_to(Matrix3D::SAMPLE_A.determinant * Matrix3D::SAMPLE_B.determinant)
  end

  it 'expresses the determinant of an inverse matrix' do
    expect(Matrix3D::SAMPLE_A.inverse.determinant)
      .to be_close_to(1.0 / Matrix3D::SAMPLE_A.determinant)
  end

  it 'expresses scalar factorization for the determinant' do
    expect((Matrix3D::SAMPLE_A * 7.0).determinant)
      .to be_close_to((7.0 ** 3) * Matrix3D::SAMPLE_A.determinant)
    expect((Matrix3D::SAMPLE_B * 2.0).determinant)
      .to be_close_to((2.0 ** 3) * Matrix3D::SAMPLE_B.determinant)
  end

  it 'expresses transpose symmetry for the determinant' do
    expect(Matrix3D::SAMPLE_A.transpose.determinant)
      .to be_close_to(Matrix3D::SAMPLE_A.determinant)
  end
end
