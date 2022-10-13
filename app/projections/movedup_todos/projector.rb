module EventSourceryTodoApp
  module Projections
    module MovedupTodos
      class Projector
        include EventSourcery::Postgres::Projector

        projector_name :movedup_todos

        table :query_movedup_todos do 
          column :todo_id, 'UUID NOT NULL'
          column :title, :text
          column :description, :text
          column :due_date, DateTime
          column :stakeholder_email, :text
        end

        project TodoMoveup do |event|
          table.insert(
            todo_id: event.aggregate_id,
            title: event.body['title'],
            description: event.body['description'],
            due_date: event.body['due_date'],
            stakeholder_email: event.body['stakeholder_email'],
          )
        end

        project TodoAmended do |event|
          table.where(
            todo_id: event.aggregate_id,
          ).update(
            event.body.slice('title', 'description', 'due_date', 'stakeholder_email')
          )
        end

        project TodoCompleted, TodoAbandoned do |event|
          table.where(todo_id: event.aggregate_id).delete
        end

      end
    end
  end
end