require 'json'
require 'yaml'

module TPS
  module Importer
    def self.create(file, format=nil)
      TPS::Importer::Trello.new file
    end

    class Base
      def initialize(file)
        @file = file
        @tree = Hash.new
      end

      def to_yaml
        YAML::dump @tree
      end
    end

    class Trello < Base
      def initialize(file)
        super
        @data = JSON.parse(File.read(@file))
        @tree = Hash.new
        work!
      end

      def milestone
        name = @data['name'] + ' milestone'
        @tree[name] ||= Hash.new
      end

      def archived
        name = @data['name'] + ' archived milestone'
        @tree[name] ||= Hash.new
      end

      def work!
        milestone
        archived

        @lists ||= Hash.new
        @data['lists'].each do |list|

          parent = list['closed'] ? archived : milestone
          parent[list['name']] ||= Hash.new

          @lists[list['id']] = parent[list['name']]
        end

        @data['cards'].each do |card|
          parent = @lists[card['idList']]

          labels = card['labels'].map { |l| l['name'].downcase }

          value = Array.new
          value << 'done'  if labels.include?("done")
          value << 'in progress'  if labels.include?("in progress")

          parent[card['name']] = value.empty? ? nil : value
        end
      end
    end
  end
end

