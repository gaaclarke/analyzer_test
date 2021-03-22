import 'dart:io' show File;
import 'package:analyzer/dart/analysis/analysis_context_collection.dart' show AnalysisContextCollection;
import 'package:analyzer/dart/analysis/analysis_context.dart' show AnalysisContext;
import 'package:analyzer/dart/analysis/results.dart' show ParsedUnitResult;
import 'package:analyzer/dart/analysis/session.dart' show AnalysisSession;
import 'package:analyzer/dart/ast/ast.dart' show CompilationUnit;
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:path/path.dart' as path;

class _Visitor<R> extends RecursiveAstVisitor<R> {
  @override
  R? visitImportDirective(ImportDirective node) {
    StringLiteral importString = node.childEntities.toList()[1] as StringLiteral;
    print(importString.stringValue);
    return super.visitImportDirective(node);
  }
}

void main(List<String> args) {
  if (args.length != 1) {
    print('usage: analyzer_test <path to dart file>');
    return;
  }
  final File input = File(args[0]);
  
  List<String> includedPaths = <String>[path.normalize(input.absolute.path)];
  AnalysisContextCollection collection =
      AnalysisContextCollection(includedPaths: includedPaths);
  
  for (AnalysisContext context in collection.contexts) {
    for (final String path in context.contextRoot.analyzedFiles()) {
      final AnalysisSession session = context.currentSession;
      ParsedUnitResult result = session.getParsedUnit(path);
      CompilationUnit unit = result.unit;
      _Visitor<int> visitor = _Visitor();
      unit.accept(visitor);
    }
  }
}
