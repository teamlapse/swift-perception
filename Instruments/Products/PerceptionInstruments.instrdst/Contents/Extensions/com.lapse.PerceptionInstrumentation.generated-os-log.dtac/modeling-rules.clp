(deftemplate MODELER::consumed-end
    (slot end-fact (type FACT-ADDRESS))
    (slot rule-system-serial (type INTEGER))
    (slot output-table (type INTEGER))
)
(defrule MODELER::purge-consumed-ends
    ?f <- (consumed-end)  ;; clean up all transient facts for the next RECORDER pass
    =>
    (retract ?f)
)

(deftemplate MODELER::open-start-interval
    (slot time (type INTEGER))
    (slot identifier (type INTEGER))
    (slot subsystem (type STRING))
    (slot category (type STRING))
    (slot name (type STRING))
    (slot thread (type EXTERNAL-ADDRESS SYMBOL) (allowed-symbols sentinel) (default ?NONE))
    (slot process (type EXTERNAL-ADDRESS SYMBOL) (allowed-symbols sentinel) (default ?NONE))
    (multislot message$)
    (slot message (type EXTERNAL-ADDRESS SYMBOL) (allowed-symbols sentinel) (default sentinel))
    (slot user-backtrace (type EXTERNAL-ADDRESS SYMBOL) (allowed-symbols sentinel))
    (slot rule-system-serial (type INTEGER))
    (slot output-table (type INTEGER))
    (multislot layout-category (default ?NONE))
    (slot layout-id (type INTEGER SYMBOL))
)
(deftemplate MODELER::matched-interval
    (slot open-fact (type FACT-ADDRESS))
    (slot end-fact (type FACT-ADDRESS))
    (slot rule-system-serial (type INTEGER))
    (slot output-table (type INTEGER))
)

(defrule RECORDER::record-point-for-system-1 
    (table-attribute (table-id ?autoOutput_) (has schema perception-mutation-schema))
    (table (table-id ?autoOutput_) (side append))
    (os-signpost 
            (category "PerceptionTracked")
            (subsystem "com.lapse.perception")
            (time ?autoPointTimeBinding_&~0)
            (event-type "Event")
            (message$ "Model:" ?model-name ",Property:" ?property-name ",OldValue:" ?old-value ",NewValue:" ?new-value)
            (identifier ?autoSignpostIdentifier_)
            (name "Mutation")
    )

    =>

    (create-new-row ?autoOutput_)

    (set-column timestamp ?autoPointTimeBinding_)
    (set-column old-value ?old-value)
    (set-column new-value ?new-value)
    (set-column model-name ?model-name)
    (set-column property-name ?property-name)
)

