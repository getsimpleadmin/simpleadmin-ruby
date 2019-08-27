# frozen_string_literal: true

require 'date'

module Simpleadmin
  module Adapters
    # Postgres adapter for API endpoints
    #
    # @since 1.0.0
    class Postgres < Base
      def tables
        table_names.map do |table_name|
          {
            table_name: table_name,
            table_columns: columns_by_table_name(table_name)
          }
        end.to_json
      end

      def table_columns(table_name)
        columns_by_table_name(table_name).to_json
      end

      def resources(permitted_params_values)
        table_name, table_fields, per_page, page, query, model_attributes, sort = *permitted_params_values

        per_page = per_page.to_i
        page = page.to_i

        total = client.from(table_name).count
        resources = client.from(table_name).limit(per_page)

        resources, total = *search(query, table_name, model_attributes) unless query.nil? || query.empty?

        resources = resources.offset((per_page * page) - per_page).select(*table_field_names(table_fields))

        if order_asc?(sort['order'])
          resources = resources.order(Sequel.asc(sort['column_name'].to_sym))
        elsif order_desc?(sort['order'])
          resources = resources.order(Sequel.desc(sort['column_name'].to_sym))
        end

        {
          resources: Decorators::FieldsDecorator.call(resources, table_name, table_fields),
          total: total
        }.to_json
      end

      def resource(resource_id, table_name, table_fields)
        resource = client.from(table_name).first(id: resource_id).slice(*table_field_names(table_fields))

        Decorators::FieldsDecorator.call([resource], table_name, table_fields).first.to_json
      end

      def create_resource(table_name, resource_params)
        Config.on_create.call(model_class_by_table_name(table_name), resource_params)
      end

      def update_resource(table_name, resource_id, resource_params, _primary_key=:id)
        Config.on_update.call(model_class_by_table_name(table_name), resource_id, resource_params)
      end

      def destroy_resouce(table_name, resource_id, _primary_key=:id)
        Config.on_destroy.call(model_class_by_table_name(table_name), resource_id)
      end

      def quantity(table_name)
        {
          widget_name: :quantity,
          result: client.from(table_name).count
        }.to_json
      end

      def week_statistic(table_name)
        result = 6.downto(0).map do |day|
          current_date_time = DateTime.now - day

          client.from(table_name).where(
            created_at: beggining_of_day(current_date_time)..at_end_of_day(current_date_time)
          ).count
        end

        {
          widget_name: :week_statistic,
          result: result
        }.to_json
      end

      private

      def client
        if DatabaseClient.client.nil?
          DatabaseClient.instance.client = Sequel.connect(database_credentials)
        else
          DatabaseClient.client
        end
      end

      def beggining_of_day(date)
        DateTime.new(date.year, date.month, date.day, 0, 0, 0, 0)
      end

      def at_end_of_day(date)
        DateTime.new(date.year, date.month, date.day, 23, 59, 59, 59)
      end

      def columns_by_table_name(name)
        client.schema(name).map do |column_attributes|
          column_name, column_information = *column_attributes

          {
            column_name: column_name,
            data_type: column_information[:db_type]
          }
        end
      end

      def search(search_query, table_name, model_attributes)
        query_expressions = model_attributes.map do |model_attribute|
          Sequel.like(model_attribute.to_sym, "%#{search_query}%")
        end

        query = query_expressions.first if query_expressions.one?

        query_expressions.each_cons(2) do |current_value, next_value|
          query = query.nil? ? current_value | next_value : query | (current_value | next_value)
        end

        [
          client.from(table_name).where(query),
          client.from(table_name).where(query).count
        ]
      end
    end
  end
end
