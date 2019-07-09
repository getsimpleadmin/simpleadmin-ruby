# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Simpleadmin::DatabaseConnector do
  let(:instance) { described_class.new(database_credentials: database_credentials) }

  describe '#client' do
    let(:database_credentials) do
      { adapter: :postgres, database: 'database' }
    end

    subject { instance.client }

    it { expect { subject }.to_not raise_error(ArgumentError) }

    context 'when invalid adapter name' do
      let(:database_credentials) do
        { adapter: :invalid, database: 'database' }
      end

      it { expect { subject }.to raise_error(ArgumentError, 'Invalid adapter name or adapter not exist') }
    end
  end
end
