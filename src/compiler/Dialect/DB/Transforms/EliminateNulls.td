include "lingodb/compiler/Dialect/DB/IR/DBOps.td"
include "mlir/Dialect/Arith/IR/ArithOps.td"
include "mlir/IR/PatternBase.td"


def CreateTrueAttr : NativeCodeCall<"$_builder.getIntegerAttr($_builder.getI1Type(),1)">;
def EliminateIsNull : Pat<(DB_IsNullOp (DB_AsNullableOp $val, $null) ), (replaceWithValue $null)>;
def EliminateDeriveTruthNonNullable : Pat<(DB_DeriveTruth $val ), (replaceWithValue $val),[(Constraint<CPred<"!mlir::isa<lingodb::compiler::dialect::db::NullableType>($0.getType())">> $val)]>;
def EliminateDeriveTruthNullable : Pat<(DB_DeriveTruth $val ), (Arith_AndIOp (Arith_XOrIOp (DB_IsNullOp $val), (Arith_ConstantOp (CreateTrueAttr))) , (DB_NullableGetVal $val)),[(Constraint<CPred<"mlir::isa<lingodb::compiler::dialect::db::NullableType>($0.getType())">> $val)]>;
//def SimplifyNullableCondSkip : Pat<(CondSkipOp $cond, $args), (CondSkipOp (DB_DeriveTruth $cond), $args),[(Constraint<CPred<"mlir::isa<lingodb::compiler::dialect::db::NullableType>($0.getType())">> $cond)]>;
