variable "df_tag_dev" {
  default = {
    company    = "Mcredit"
    evn        = "dev"
    maintainer = "vhud"
  }
  description = "Default Tags for all resource"
  type        = map(string)
}

variable "df_tag_uat" {
  default = {
    company    = "Mcredit"
    evn        = "uat"
    maintainer = "vhud"
  }
  description = "Default Tags for all resource"
  type        = map(string)
}

variable "df_tag_sit" {
  default = {
    company    = "Mcredit"
    evn        = "sit"
    maintainer = "vhud"
  }
  description = "Default Tags for all resource"
  type        = map(string)
}

variable "df_tag_stag" {
  default = {
    company    = "Mcredit"
    evn        = "stag"
    maintainer = "vhud"
  }
  description = "Default Tags for all resource"
  type        = map(string)
}

variable "df_tag_prod" {
  default = {
    company    = "Mcredit"
    evn        = "prod"
    maintainer = "vhud"
  }
  description = "Default Tags for all resource"
  type        = map(string)
}

variable "ecr_policy" {
  default = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
      {
          "Sid" : "AllowPushPull",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : [
              "arn:aws:iam::264287249003:root",
              "arn:aws:iam::293803882596:root",
              "arn:aws:iam::285484073914:root",
              "arn:aws:iam::625582364686:root",
              "arn:aws:iam::997597389960:root",
              "arn:aws:iam::556256747769:root",
              "arn:aws:iam::551251594552:root",
              "arn:aws:iam::345574256244:root",
              "arn:aws:iam::833461204830:root",
              "arn:aws:iam::173630086948:root",
              "arn:aws:iam::657214670158:root",
              "arn:aws:iam::870670350144:root",
              "arn:aws:iam::514350335637:root",
              "arn:aws:iam::147426898968:root",
              "arn:aws:iam::061624541774:root",
              "arn:aws:iam::441162141182:root",
              "arn:aws:iam::651377972343:root",
              "arn:aws:iam::409779861615:root",
              "arn:aws:iam::033098051917:root",
              "arn:aws:iam::978444423615:root"
            ]
          },
          "Action" : [
            "ecr:BatchCheckLayerAvailability",
            "ecr:BatchGetImage",
            "ecr:CompleteLayerUpload",
            "ecr:GetDownloadUrlForLayer",
            "ecr:InitiateLayerUpload",
            "ecr:PutImage",
            "ecr:UploadLayerPart",
            "ecr:DescribeImages"
          ]
        }
    ]
}
EOF
}

# variable "ecr_policy" {
#   default = {
#     policy = {
#       "Version" : "2008-10-17",
#       "Statement" : [
#         {
#           "Sid" : "AllowPushPull",
#           "Effect" : "Allow",
#           "Principal" : {
#             "AWS" : [
#               "arn:aws:iam::264287249003:root",
#               "arn:aws:iam::293803882596:root",
#               "arn:aws:iam::285484073914:root",
#               "arn:aws:iam::625582364686:root",
#               "arn:aws:iam::997597389960:root",
#               "arn:aws:iam::556256747769:root",
#               "arn:aws:iam::551251594552:root",
#               "arn:aws:iam::345574256244:root",
#               "arn:aws:iam::833461204830:root",
#               "arn:aws:iam::173630086948:root",
#               "arn:aws:iam::657214670158:root",
#               "arn:aws:iam::870670350144:root",
#               "arn:aws:iam::514350335637:root",
#               "arn:aws:iam::147426898968:root",
#               "arn:aws:iam::061624541774:root",
#               "arn:aws:iam::441162141182:root",
#               "arn:aws:iam::651377972343:root",
#               "arn:aws:iam::409779861615:root"
#             ]
#           },
#           "Action" : [
#             "ecr:BatchCheckLayerAvailability",
#             "ecr:BatchGetImage",
#             "ecr:CompleteLayerUpload",
#             "ecr:GetDownloadUrlForLayer",
#             "ecr:InitiateLayerUpload",
#             "ecr:PutImage",
#             "ecr:UploadLayerPart"
#           ]
#         }
#       ]
#     }
#   }
# }
variable "replication_task_settings" {
  default = {
    BeforeImageSettings = null
    ChangeProcessingDdlHandlingPolicy = {
      HandleSourceTableAltered   = true
      HandleSourceTableDropped   = true
      HandleSourceTableTruncated = true
    }
    ChangeProcessingTuning = {
      BatchApplyMemoryLimit         = 500
      BatchApplyPreserveTransaction = true
      BatchApplyTimeoutMax          = 30
      BatchApplyTimeoutMin          = 1
      BatchSplitSize                = 0
      CommitTimeout                 = 1
      MemoryKeepTime                = 60
      MemoryLimitTotal              = 1024
      MinTransactionSize            = 1000
      StatementCacheSize            = 50
    }
    CharacterSetSettings = null
    ControlTablesSettings = {
      ControlSchema                 = ""
      FullLoadExceptionTableEnabled = false
      HistoryTableEnabled           = false
      HistoryTimeslotInMinutes      = 5
      StatusTableEnabled            = false
      SuspendedTablesTableEnabled   = false
    }
    ErrorBehavior = {
      ApplyErrorDeletePolicy                      = "IGNORE_RECORD"
      ApplyErrorEscalationCount                   = 0
      ApplyErrorEscalationPolicy                  = "LOG_ERROR"
      ApplyErrorFailOnTruncationDdl               = false
      ApplyErrorInsertPolicy                      = "LOG_ERROR"
      ApplyErrorUpdatePolicy                      = "LOG_ERROR"
      DataErrorEscalationCount                    = 0
      DataErrorEscalationPolicy                   = "SUSPEND_TABLE"
      DataErrorPolicy                             = "LOG_ERROR"
      DataTruncationErrorPolicy                   = "LOG_ERROR"
      FailOnNoTablesCaptured                      = true
      FailOnTransactionConsistencyBreached        = false
      FullLoadIgnoreConflicts                     = true
      RecoverableErrorCount                       = -1
      RecoverableErrorInterval                    = 5
      RecoverableErrorStopRetryAfterThrottlingMax = true
      RecoverableErrorThrottling                  = true
      RecoverableErrorThrottlingMax               = 1800
      TableErrorEscalationCount                   = 0
      TableErrorEscalationPolicy                  = "STOP_TASK"
      TableErrorPolicy                            = "SUSPEND_TABLE"
    }
    FailTaskWhenCleanTaskResourceFailed = false
    FullLoadSettings = {
      CommitRate                      = 10000
      CreatePkAfterFullLoad           = false
      MaxFullLoadSubTasks             = 8
      StopTaskCachedChangesApplied    = false
      StopTaskCachedChangesNotApplied = false
      TargetTablePrepMode             = "DO_NOTHING"
      TransactionConsistencyTimeout   = 600
    }
    Logging = {
      EnableLogging = true
      LogComponents = [
        {
          Id       = "TRANSFORMATION"
          Severity = "LOGGER_SEVERITY_DEFAULT"
        },
        {
          Id       = "SOURCE_UNLOAD"
          Severity = "LOGGER_SEVERITY_DETAILED_DEBUG"
        },
        {
          Id       = "IO"
          Severity = "LOGGER_SEVERITY_DEFAULT"
        },
        {
          Id       = "TARGET_LOAD"
          Severity = "LOGGER_SEVERITY_DETAILED_DEBUG"
        },
        {
          Id       = "PERFORMANCE"
          Severity = "LOGGER_SEVERITY_DEFAULT"
        },
        {
          Id       = "SOURCE_CAPTURE"
          Severity = "LOGGER_SEVERITY_DETAILED_DEBUG"
        },
        {
          Id       = "SORTER"
          Severity = "LOGGER_SEVERITY_DEFAULT"
        },
        {
          Id       = "REST_SERVER"
          Severity = "LOGGER_SEVERITY_DEFAULT"
        },
        {
          Id       = "VALIDATOR_EXT"
          Severity = "LOGGER_SEVERITY_DEFAULT"
        },
        {
          Id       = "TARGET_APPLY"
          Severity = "LOGGER_SEVERITY_DETAILED_DEBUG"
        },
        {
          Id       = "TASK_MANAGER"
          Severity = "LOGGER_SEVERITY_DETAILED_DEBUG"
        },
        {
          Id       = "TABLES_MANAGER"
          Severity = "LOGGER_SEVERITY_DEFAULT"
        },
        {
          Id       = "METADATA_MANAGER"
          Severity = "LOGGER_SEVERITY_DEFAULT"
        },
        {
          Id       = "FILE_FACTORY"
          Severity = "LOGGER_SEVERITY_DEFAULT"
        },
        {
          Id       = "COMMON"
          Severity = "LOGGER_SEVERITY_DEFAULT"
        },
        {
          Id       = "ADDONS"
          Severity = "LOGGER_SEVERITY_DEFAULT"
        },
        {
          Id       = "DATA_STRUCTURE"
          Severity = "LOGGER_SEVERITY_DEFAULT"
        },
        {
          Id       = "COMMUNICATION"
          Severity = "LOGGER_SEVERITY_DEFAULT"
        },
        {
          Id       = "FILE_TRANSFER"
          Severity = "LOGGER_SEVERITY_DEFAULT"
        },
      ]
    }
    LoopbackPreventionSettings = null
    PostProcessingRules        = null
    StreamBufferSettings = {
      CtrlStreamBufferSizeInMB = 5
      StreamBufferCount        = 3
      StreamBufferSizeInMB     = 8
    }
    TargetMetadata = {
      BatchApplyEnabled            = false
      FullLobMode                  = true
      InlineLobMaxSize             = 0
      LimitedSizeLobMode           = false
      LoadMaxFileSize              = 0
      LobChunkSize                 = 64
      LobMaxSize                   = 0
      ParallelApplyBufferSize      = 0
      ParallelApplyQueuesPerThread = 0
      ParallelApplyThreads         = 0
      ParallelLoadBufferSize       = 0
      ParallelLoadQueuesPerThread  = 0
      ParallelLoadThreads          = 0
      SupportLobs                  = true
      TargetSchema                 = ""
      TaskRecoveryTableEnabled     = false
    }
    ValidationSettings = {
      EnableValidation                 = true
      FailureMaxCount                  = 10000
      HandleCollationDiff              = false
      MaxKeyColumnSize                 = 8096
      PartitionSize                    = 10000
      RecordFailureDelayInMinutes      = 5
      RecordFailureDelayLimitInMinutes = 0
      RecordSuspendDelayInMinutes      = 30
      SkipLobColumns                   = false
      TableFailureMaxCount             = 1000
      ThreadCount                      = 5
      ValidationMode                   = "ROW_LEVEL"
      ValidationOnly                   = false
      ValidationPartialLobSize         = 0
      ValidationQueryCdcDelaySeconds   = 0
    }
  }
}
variable "ecr_name" {
  type        = string
  description = "ecr_name"
}
variable "tags" {
  type        = map(string)
  description = "tags"
}
