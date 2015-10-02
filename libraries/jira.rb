# Chef class
class Chef
  # Chef::Recipe class
  class Recipe
    # Chef::Recipe::Jira class
    class Jira
      def self.settings(node)
        @@settings_from_data_bag ||= settings_from_data_bag(node)
        settings = Chef::Mixin::DeepMerge.deep_merge(
          @@settings_from_data_bag,
          node[cookbook_name].to_hash
        )

        case settings['database']['type']
        when 'mysql'
          settings['database']['port'] ||= 3306
        when 'postgresql'
          settings['database']['port'] ||= 5432
        else
          fail "Unsupported database type: #{settings['database']['type']}"
        end

        settings


      end

      # Fetchs application settings from the data bag
      #
      # @return [Hash] Settings hash
      def self.settings_from_data_bag(node)
        item =
        begin
          if Chef::Config[:solo]
            Chef::DataBagItem.load(cookbook_name, cookbook_name)['local']
          else
            Chef::EncryptedDataBagItem.load(cookbook_name, cookbook_name)[node.chef_environment]
          end
        rescue
          Chef::Log.info("No #{cookbook_name} data bag found")
          nil
        end

        item || {}
      end

      def self.cookbook_name
        'jira'
      end

    end
  end
end
