resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "additionalProperties" = true,
        "properties" = {
            "callbackNumber" = {
                "type" = "string"
            },
            "callbackScheduledTime" = {
                "type" = "string"
            },
            "callbackUserName" = {
                "type" = "string"
            },
            "languageId" = {
                "type" = "string"
            },
            "participantdataareaofinterest" = {
                "type" = "string"
            },
            "participantdatacallbacktime" = {
                "type" = "string"
            },
            "participantdatacsagentname" = {
                "type" = "string"
            },
            "participantdataname" = {
                "type" = "string"
            },
            "participantdataphonenumber" = {
                "type" = "string"
            },
            "preferredAgentId" = {
                "type" = "string"
            },
            "priority" = {
                "type" = "string"
            },
            "queueId" = {
                "type" = "string"
            },
            "scriptId" = {
                "type" = "string"
            },
            "skillId" = {
                "type" = "string"
            }
        },
        "required" = [
            "callbackNumber",
            "queueId"
        ],
        "type" = "object"
    })
    contract_output = jsonencode({
        "additionalProperties" = true,
        "properties" = {
            "conversationId" = {
                "type" = "string"
            }
        },
        "type" = "object"
    })
    
    config_request {
        request_template     = "{\n  \"callbackNumbers\": [ \"$${input.callbackNumber}\" ],\n#if(\"$!{input.scriptId}\" != \"\")\n  \"scriptId\": \"$!{input.scriptId}\",\n#end\n#if(\"$!{input.callbackUserName}\" != \"\")\n  \"callbackUserName\": \"$!{input.callbackUserName}\",\n#end\n#if(\"$!{input.callbackScheduledTime}\" != \"\")\n  \"callbackScheduledTime\": \"$!{input.callbackScheduledTime}\",\n#end\n  \"routingData\": {\n    \"queueId\": \"$${input.queueId}\"\n#if(\"$!{input.languageId}\" != \"\")\n    ,\"languageId\": \"$!{input.languageId}\"\n#end\n#if(\"$!{input.priority}\" != \"\")\n    ,\"priority\": $!{input.priority}\n#end\n#if(\"$!{input.preferredAgentId}\" != \"\")\n    ,\"scoredAgents\": [ { \"agent\": { \"id\": \"$!{input.preferredAgentId}\" }, \"score\": 100 } ]\n#end\n#if(\"$!{input.skillId}\" != \"\")\n    ,\"skillIds\": [ \"$!{input.skillId}\" ]\n#end\n  },\n\"data\": {\n  \"Phone Number\": \"$${input.participantdataphonenumber}\",\n  \"Name\": \"$${input.participantdataname}\",\n  \"Area Of Interest\": \"$${input.participantdataareaofinterest}\",\n  \"CS Agent Name\": \"$${input.participantdatacsagentname}\",\n  \"Date/Time\": \"$${input.participantdatacallbacktime}\"\n}\n}"
        request_type         = "POST"
        request_url_template = "/api/v2/conversations/callbacks"
        
    }

    config_response {
        success_template = "{ \"conversationId\": $${id} }"
        translation_map = { 
			id = "$.conversation.id"
		}
        translation_map_defaults = {       
			id = "\"\""
		}
    }
}