json.transaction_id @transaction.id
case params[:action]
when 'create'
  json.recommendation @transaction.recommendation ? 'approve' : 'deny'
when 'update'
  json.has_cbk @transaction.has_cbk ? true : false
end
