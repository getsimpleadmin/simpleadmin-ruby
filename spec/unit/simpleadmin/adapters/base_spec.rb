# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Simpleadmin::Adapters::Base do
  let(:instance) { described_class.new(database_credentials: database_credentials) }

  let(:database_credentials) do
    { adapter: :postgres, database: 'database' }
  end

  describe '#tables' do
    subject { instance.tables }

    it {
      expect { subject }.to raise_error(
        NotImplementedError,
        'Please follow the unified interface, add method #tables'
      )
    }
  end

  describe '#table_columns' do
    subject { instance.table_columns }

    it {
      expect { subject }.to raise_error(
        NotImplementedError,
        'Please follow the unified interface, add method #table_columns'
      )
    }
  end

  describe '#resources' do
    subject { instance.resources }

    it {
      expect { subject }.to raise_error(
        NotImplementedError,
        'Please follow the unified interface, add method #resources'
      )
    }
  end
end
