class TodoSerializer < ActiveModel::Serializer
  attributes :id, :title, :status
end
