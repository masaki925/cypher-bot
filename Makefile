
FQDN=http://localhost:3000
APP_URL=$(FQDN)/api/raps/battle
APP_URL_PEE=$(FQDN)/api/raps/battle_with_pee
APP_URL_MARCO=$(FQDN)/api/raps/battle_with_marco
APP_URL_TOBA=$(FQDN)/api/raps/battle_with_toba
APP_URL_DOKABEN=$(FQDN)/api/raps/battle_with_dokaben
QUERY=おまえの母ちゃんデベソ

usage:
	@echo "make dt             # dialog test"
	@echo "                    #   e.g.:"
	@echo "                    #     make dt QUERY=おまえの母ちゃんデベソ"
	@echo "make dt_pee         # dialog test (pee version)"
	@echo "                    #   e.g.:"
	@echo "                    #     make dt_pee QUERY=おまえの母ちゃんデベソ"
	@echo "make dt_marco       # dialog test (marco version)"
	@echo "                    #   e.g.:"
	@echo "                    #     make dt_marco QUERY=おまえの母ちゃんデベソ"
	@echo "make dt_toba        # dialog test (toba version)"
	@echo "                    #   e.g.:"
	@echo "                    #     make dt_toba QUERY=おまえの母ちゃんデベソ"
	@echo "make dt_dokaben     # dialog test (dokaben version)"
	@echo "                    #   e.g.:"
	@echo "                    #     make dt_dokaben QUERY=おまえの母ちゃんデベソ。おまえの父ちゃん寝ゲロ"


dt:
	curl -v -H "Accept: application/json" -H "Content-type: application/json" -H "X_LINE_DEBUG_USER_ID: $(LINE_DEBUG_USER_ID)" -X POST -d '{ "events": [{ "replyToken": "XXX", "type": "message", "source": { "type": "user", "userId": "XXXXX" }, "message": { "id": "1234", "type": "text", "text": "$(QUERY)" } }] }' $(APP_URL)

dt_pee:
	curl -v -H "Accept: application/json" -H "Content-type: application/json" -H "X_LINE_DEBUG_USER_ID: $(LINE_DEBUG_USER_ID)" -X POST -d '{ "events": [{ "replyToken": "XXX", "type": "message", "source": { "type": "user", "userId": "XXXXX" }, "message": { "id": "1234", "type": "text", "text": "$(QUERY)" } }] }' $(APP_URL_PEE)

dt_marco:
	curl -v -H "Accept: application/json" -H "Content-type: application/json" -H "X_LINE_DEBUG_USER_ID: $(LINE_DEBUG_USER_ID)" -X POST -d '{ "events": [{ "replyToken": "XXX", "type": "message", "source": { "type": "user", "userId": "XXXXX" }, "message": { "id": "1234", "type": "text", "text": "$(QUERY)" } }] }' $(APP_URL_MARCO)

dt_toba:
	curl -v -H "Accept: application/json" -H "Content-type: application/json" -H "X_LINE_DEBUG_USER_ID: $(LINE_DEBUG_USER_ID)" -X POST -d '{ "events": [{ "replyToken": "XXX", "type": "message", "source": { "type": "user", "userId": "XXXXX" }, "message": { "id": "1234", "type": "text", "text": "$(QUERY)" } }] }' $(APP_URL_TOBA)

dt_dokaben:
	curl -v -H "Accept: application/json" -H "Content-type: application/json" -H "X_LINE_DEBUG_USER_ID: $(LINE_DEBUG_USER_ID)" -X POST -d '{ "events": [{ "replyToken": "XXX", "type": "message", "source": { "type": "user", "userId": "XXXXX" }, "message": { "id": "1234", "type": "text", "text": "$(QUERY)" } }] }' $(APP_URL_DOKABEN)

