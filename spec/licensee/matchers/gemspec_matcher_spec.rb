RSpec.describe Licensee::Matchers::Gemspec do
  let(:mit) { Licensee::License.find('mit') }
  let(:content) { "s.license = 'mit'" }
  let(:file) do
    Licensee::ProjectFiles::LicenseFile.new(content, 'project.gemspec')
  end
  subject { described_class.new(file) }

  it 'matches' do
    expect(subject.match).to eql(mit)
  end

  it 'has confidence' do
    expect(subject.confidence).to eql(90)
  end

  {
    'as spec.'      => "spec.license = 'mit'",
    'double quotes' => 's.license = "mit"',
    'no whitespace' => "s.license='mit'",
    'uppercase'     => "s.license = 'MIT'"
  }.each do |description, license_declaration|
    context "with a #{description} declaration" do
      let(:content) { license_declaration }

      it 'matches' do
        expect(subject.match).to eql(mit)
      end
    end
  end

  context 'no license field' do
    let(:content) { "s.foo = 'bar'" }

    it 'returns nil' do
      expect(subject.match).to be_nil
    end
  end

  context 'an unknown license' do
    let(:content) { "s.license = 'foo'" }

    it 'returns other' do
      expect(subject.match).to eql(Licensee::License.find('other'))
    end
  end
end
