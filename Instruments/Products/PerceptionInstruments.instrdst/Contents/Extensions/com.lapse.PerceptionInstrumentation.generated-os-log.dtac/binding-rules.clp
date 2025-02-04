(deftemplate modeler-instance (slot instance))
(deftemplate modeler-instance-binding (slot instance) (slot rule))
(deftemplate modeler-instance-bound-watchable (slot instance) (slot table-id) (slot watch-id))
(deftemplate modeler-instance-param (slot instance) (slot name) (multislot value))

(defrule binding-rule-1
    (declare (salience 120))
    (unbound-table-instance (table-id ?t0__) (has schema perception-mutation-schema))
    (unbound-table-instance (table-id ?t0__) (has target-pid $?target-pid))
    ?mod-inst-fact__ <- (modeler-instance (instance ?instance__))
    (not (modeler-instance-param (instance ?instance__) (name target-pid) (value ~$?target-pid)))
    =>
    (if (eq ?instance__ FALSE) then (bind ?instance__ (create-modeler-instance)) (modify ?mod-inst-fact__ (instance ?instance__)) else (set-modeler-instance-to ?instance__))
    (assert (modeler-instance-binding (instance ?instance__) (rule 1)))
    (bind-output-table ?t0__)
    (bind-input-table os-signpost (attribute target-pid $?target-pid) (attribute category PerceptionTracked) (attribute subsystem "com.lapse.perception"))
    (assert (modeler-instance-param (instance ?instance__) (name target-pid) (value ?target-pid)))
)
(defrule bootstrap-rule-1
    (declare (salience -100))
    (not (modeler-instance (instance FALSE)))
    (unbound-table-instance (table-id ?t0__) (has schema perception-mutation-schema))
    (unbound-table-instance (table-id ?t0__) (has target-pid $?target-pid))
    =>
    (assert (modeler-instance (instance FALSE)))
)
(defrule binding-rule-2
    (declare (salience 110))
    (unbound-table-instance (table-id ?t0__) (has schema perception-mutation-schema))
    ?mod-inst-fact__ <- (modeler-instance (instance ?instance__))
    =>
    (if (eq ?instance__ FALSE) then (bind ?instance__ (create-modeler-instance)) (modify ?mod-inst-fact__ (instance ?instance__)) else (set-modeler-instance-to ?instance__))
    (assert (modeler-instance-binding (instance ?instance__) (rule 2)))
    (bind-output-table ?t0__)
    (bind-input-table os-signpost (attribute subsystem "com.lapse.perception") (attribute category PerceptionTracked))
)
(defrule bootstrap-rule-2
    (declare (salience -100))
    (not (modeler-instance (instance FALSE)))
    (unbound-table-instance (table-id ?t0__) (has schema perception-mutation-schema))
    =>
    (assert (modeler-instance (instance FALSE)))
)
