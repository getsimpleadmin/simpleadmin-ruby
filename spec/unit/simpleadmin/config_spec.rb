# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Simpleadmin::Config do
  describe '.allowed_tables' do
    subject { described_class.allowed_tables }

    context 'when allowed_tables is not defined' do
      it { expect(subject).to eq [] }
    end
  end

  describe '.table_schemas' do
    subject { described_class.table_schemas }

    context 'when table_schemas is not defined' do
      it { expect(subject).to eq described_class::DEFAULT_TABLE_SCHEMAS }
    end
  end
end
