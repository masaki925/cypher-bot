
FQDN=http://localhost:3000
APP_URL=$(FQDN)/api/raps/battle
QUERY=おまえの母ちゃんデベソ

usage:
	@echo "make dt             # dialog test"
	@echo "                    #   e.g.:"
	@echo "                    #     make dt QUERY=おまえの母ちゃんデベソ"

dt:
	curl -v -H "Accept: application/json" -H "Content-type: application/json" -H "X_LINE_DEBUG_USER_ID: $(LINE_DEBUG_USER_ID)" -X POST -d '{ "events": [{ "replyToken": "XXX", "type": "message", "source": { "type": "user", "userId": "XXXXX" }, "message": { "id": "1234", "type": "text", "text": "$(QUERY)" } }] }' $(APP_URL)

