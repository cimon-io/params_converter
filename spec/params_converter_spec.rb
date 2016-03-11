require 'spec_helper'
require 'params_converter'

RSpec.describe ParamsConverter do

  context "happy path with allowed stringify keys and required stringify keys" do
    subject { ParamsConverter.convert!({ a: 1, b: 2, 'c' => 3, d: 4 }, [:a, 'b'], ['c', :d]) }

    it { expect(subject[:a]).to eq(1) }
    it { expect(subject[:b]).to eq(2) }
    it { expect(subject[:c]).to eq(3) }
    it { expect(subject[:d]).to eq(4) }
  end

  context "happy path with empty allowed keys and required keys" do
    subject { ParamsConverter.convert!({ a: 1, b: 2, c: 3, 'd' => 4 }, [:a, 'b']) }

    it { expect(subject[:a]).to eq(1) }
    it { expect(subject[:b]).to eq(2) }
    it { expect(subject[:c]).to eq(3) }
    it { expect(subject[:d]).to eq(4) }
  end

  context "happy path with empty required keys and allowed keys" do
    subject { ParamsConverter.convert!({ a: 1, b: 2, c: 3, 'd' => 4 }, [], [:a, 'b', :c, 'd']) }

    it { expect(subject[:a]).to eq(1) }
    it { expect(subject[:b]).to eq(2) }
    it { expect(subject[:c]).to eq(3) }
    it { expect(subject[:d]).to eq(4) }
  end

  context "happy path with empty allowed keys and empty required keys" do
    subject { ParamsConverter.convert!({ a: 1, b: 2, c: 3, 'd' => 4 }) }

    it { expect(subject[:a]).to eq(1) }
    it { expect(subject[:b]).to eq(2) }
    it { expect(subject[:c]).to eq(3) }
    it { expect(subject[:d]).to eq(4) }
  end

  context 'raise error' do
    it "with empty allowed keys and existing required keys" do
      expect{ ParamsConverter.convert!({ a: 1, b: 2, c: 3, 'd' => 4 }, nil, ['e']) }.to raise_error(ParamsConverter::NotAllowedError)
    end

    it "with existing allowed keys and empty required keys" do
      expect{ ParamsConverter.convert!({ a: 1, b: 2, c: 3, 'd' => 4 }, ['a', 'e']) }.to raise_error(ParamsConverter::MissingRequiredError)
    end

    it "with existing allowed keys and empty required keys" do
      expect{ ParamsConverter.convert!({ a: 1, b: 2, c: 3, 'd' => 4 }, [], []) }.to raise_error(ParamsConverter::NotAllowedError)
    end

    context "with wrong arguments" do
      it { expect{ ParamsConverter.convert!({ a: 1, b: 2, c: 3, 'd' => 4 }, :not_array, []) }.to raise_error(ArgumentError) }
      it { expect{ ParamsConverter.convert!({ a: 1, b: 2, c: 3, 'd' => 4 }, nil, :not_array) }.to raise_error(ArgumentError) }
      it { expect{ ParamsConverter.convert!(:not_hash, nil, nil) }.to raise_error(ArgumentError) }
    end
  end

end
