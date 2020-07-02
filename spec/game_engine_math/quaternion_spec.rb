# frozen_string_literal: true

RSpec.describe GameEngineMath::Quaternion do
  it 'exists' do
    expect(Quaternion).to be_an_instance_of Class
    expect(Quaternion).to eq(GameEngineMath::Quaternion)
  end

  it 'can instantiate an object' do
    q = Quaternion.new(1, 2, 3, 4)

    expect(q.x).to eq(1)
    expect(q.y).to eq(2)
    expect(q.z).to eq(3)
    expect(q.w).to eq(4)
  end

  it 'can be instantiated from a Hash' do
    q = Quaternion.from_h(x: 1, y: 2, z: 3, w: 4)

    expect(q.x).to eq(1)
    expect(q.y).to eq(2)
    expect(q.z).to eq(3)
    expect(q.w).to eq(4)
  end

  it 'can be instantiated from a Vector3D' do
    q = Quaternion.from_vector(Vector3D.new(1, 2, 3), 4)

    expect(q.x).to eq(1)
    expect(q.y).to eq(2)
    expect(q.z).to eq(3)
    expect(q.w).to eq(4)
  end

  it 'expresses the distributive property of scalar multiplication' do
    q1 = Quaternion.new(1, 2, 3, 4)
    q2 = Quaternion.new(5, 6, 7, 8)
    s1 = 5
    s2 = 7

    expect((q1 + q2) * s1).to eq((q1 * s1) + (q2 * s1))
    expect(q1 * (s1 + s2)).to eq((q1 * s1) + (q1 * s2))
  end

  it 'expresses the associative property of quaternion multiplication' do
    q1 = Quaternion.new(1, 2, 3, 4)
    q2 = Quaternion.new(5, 6, 7, 8)
    q3 = Quaternion.new(1, 5, 7, 9)

    expect(q1 * (q2 * q3)).to eq((q1 * q2) * q3)
  end

  it 'expresses the distributive property of quaternion multiplication' do
    q1 = Quaternion.new(1, 2, 3, 4)
    q2 = Quaternion.new(5, 6, 7, 8)
    q3 = Quaternion.new(1, 5, 7, 9)

    expect(q1 * (q2 + q3)).to eq((q1 * q2) + (q1 * q3))
    expect((q1 + q2) * q3).to eq((q1 * q3) + (q2 * q3))
  end

  it 'expresses the product rule for quaternion conjugation' do
    q1 = Quaternion.new(1, 2, 3, 4)
    q2 = Quaternion.new(5, 6, 7, 8)

    expect((q1 * q2).conjugate).to eq(q2.conjugate * q1.conjugate)
  end

  it 'expresses the product rule for quaternion inverse' do
    q1 = Quaternion.new(1, 2, 3, 4)
    q2 = Quaternion.new(5, 6, 7, 8)

    expect((q1 * q2).inverse).to eq(q2.inverse * q1.inverse)
  end
end
