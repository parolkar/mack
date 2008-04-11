namespace :db do
  
  desc "db:migrate"
  task :migrate => "mack:environment" do
    
    if using_data_mapper? 
      require 'data_mapper/migration'

      unless DmSchemaInfo.table.exists?
        DmSchemaInfo.table.create!
        DmSchemaInfo.create(:version => 0)
      end
      schema_info = DmSchemaInfo.first
      
    elsif using_active_record?
      require 'active_record/migration'

      unless ArSchemaInfo.table_exists?
        class CreateArSchemaInfo < ActiveRecord::Migration
          
          def self.up
            create_table :schema_info do |t|
              t.column :version, :integer, :default => 0
            end
          end
          
        end
        CreateArSchemaInfo.up
        ArSchemaInfo.create(:version => 0)
      end
      schema_info = ArSchemaInfo.find(:first)
      
    end
    
    Dir.glob(File.join(MACK_ROOT, "db", "migrations", "*.rb")).each do |migration|
      require migration
      
      migration = File.basename(migration, ".rb")
      m_number = migration.match(/(^\d+)/).captures.last.to_i
      
      if m_number > schema_info.version
      
        m_name = migration.match(/^\d+_(.+)/).captures.last
      
        m_name.camelcase.constantize.up
        
        schema_info.version += 1
        schema_info.save
      end
      
    end
  end
  
end # db