require 'app/aggregates/todo'

module EventSourceryTodoApp
  module Commands
    module Todo
      module Movedown
        class Command
          attr_reader :payload, :aggregate_id
          
          def self.build(**args)
            new(**args).tap(&:validate)
          end

          def initialize(params)
            @payload = params.slice(:todo_id)
            @aggregate_id = payload.delete(:todo_id)
          end

          def validate
          end
        end

        class CommandHandler
          def initialize(repository: EventSourceryTodoApp.repository)
            @repository = repository
          end

          def handle(command)
            aggregate = repository.load(Aggregates::Todo, command.aggregate_id)
            aggregate.movedown(command.payload)
            repository.save(aggregate)
          end

          private

          attr_reader :repository
        end
      end
    end
  end
end