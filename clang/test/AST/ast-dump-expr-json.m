// RUN: %clang_cc1 -triple x86_64-pc-win32 -Wno-unused -fblocks -ast-dump=json -ast-dump-filter Test %s | FileCheck %s

typedef long NSInteger;
typedef unsigned long NSUInteger;
typedef signed char BOOL;

@interface NSNumber
@end
@interface NSNumber (NSNumberCreation)
+ (NSNumber *)numberWithChar:(char)value;
+ (NSNumber *)numberWithUnsignedChar:(unsigned char)value;
+ (NSNumber *)numberWithShort:(short)value;
+ (NSNumber *)numberWithUnsignedShort:(unsigned short)value;
+ (NSNumber *)numberWithInt:(int)value;
+ (NSNumber *)numberWithUnsignedInt:(unsigned int)value;
+ (NSNumber *)numberWithLong:(long)value;
+ (NSNumber *)numberWithUnsignedLong:(unsigned long)value;
+ (NSNumber *)numberWithLongLong:(long long)value;
+ (NSNumber *)numberWithUnsignedLongLong:(unsigned long long)value;
+ (NSNumber *)numberWithFloat:(float)value;
+ (NSNumber *)numberWithDouble:(double)value;
+ (NSNumber *)numberWithBool:(BOOL)value;
+ (NSNumber *)numberWithInteger:(NSInteger)value;
+ (NSNumber *)numberWithUnsignedInteger:(NSUInteger)value;
@end

@interface I
{
@public
  int public;
}
- (int) conformsToProtocol : (Protocol *)protocl;
- (void)method1;
+ (void)method2;
@end

@interface J
@property unsigned prop;
@end

@protocol Proto
@end

@interface NSMutableDictionary
- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)object forKeyedSubscript:(id)key;
@end

@interface NSMutableArray
- (id)objectAtIndexedSubscript:(int)index;
- (void)setObject:(id)object atIndexedSubscript:(int)index;
@end

void TestObjCEncode() {
  @encode(int);
  @encode(typeof(^{;}));
}

void TestObjCMessage(I *Obj) {
  [Obj method1];
  [I method2];
}

void TestObjCBoxed() {
  @(1 + 1);
}

void TestObjCSelector() {
  SEL s = @selector(dealloc);
}

void TestObjCProtocol(id Obj) {
  [Obj conformsToProtocol:@protocol(Proto)];
}

void TestObjCPropertyRef(J *Obj) {
  Obj.prop = 12;
  int i = Obj.prop;
}

void TestObjCSubscriptRef(NSMutableArray *Array, NSMutableDictionary *Dict) {
 Array[0] = (void*)0;
 id i = Array[0];
 
 Dict[@"key"] = (void*)0;
 i = Dict[@"key"];
}

void TestObjCIVarRef(I *Ptr) {
  Ptr->public = 0;
}

void TestObjCBoolLiteral() {
  __objc_yes;
  __objc_no;
}


// CHECK:  "kind": "FunctionDecl", 
// CHECK-NEXT:  "loc": {
// CHECK-NEXT:   "col": 6, 
// CHECK-NEXT:   "file": "{{.*}}", 
// CHECK-NEXT:   "line": 54
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "range": {
// CHECK-NEXT:   "begin": {
// CHECK-NEXT:    "col": 1, 
// CHECK-NEXT:    "file": "{{.*}}", 
// CHECK-NEXT:    "line": 54
// CHECK-NEXT:   }, 
// CHECK-NEXT:   "end": {
// CHECK-NEXT:    "col": 1, 
// CHECK-NEXT:    "file": "{{.*}}", 
// CHECK-NEXT:    "line": 57
// CHECK-NEXT:   }
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "name": "TestObjCEncode", 
// CHECK-NEXT:  "type": {
// CHECK-NEXT:   "qualType": "void ()"
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "inner": [
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}", 
// CHECK-NEXT:    "kind": "CompoundStmt", 
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 23, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 54
// CHECK-NEXT:     }, 
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 1, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 57
// CHECK-NEXT:     }
// CHECK-NEXT:    }, 
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}", 
// CHECK-NEXT:      "kind": "ImplicitCastExpr", 
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 3, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 55
// CHECK-NEXT:       }, 
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 14, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 55
// CHECK-NEXT:       }
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "char *"
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "valueCategory": "rvalue", 
// CHECK-NEXT:      "castKind": "ArrayToPointerDecay", 
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "ObjCEncodeExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 3, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 55
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 14, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 55
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "char [2]"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "lvalue", 
// CHECK-NEXT:        "encodedType": {
// CHECK-NEXT:         "qualType": "int"
// CHECK-NEXT:        }
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }, 
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}", 
// CHECK-NEXT:      "kind": "ImplicitCastExpr", 
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 3, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 56
// CHECK-NEXT:       }, 
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 23, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 56
// CHECK-NEXT:       }
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "char *"
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "valueCategory": "rvalue", 
// CHECK-NEXT:      "castKind": "ArrayToPointerDecay", 
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "ObjCEncodeExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 3, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 56
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 23, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 56
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "char [3]"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "lvalue", 
// CHECK-NEXT:        "encodedType": {
// CHECK-NEXT:         "desugaredQualType": "void (^)(void)", 
// CHECK-NEXT:         "qualType": "typeof (^{ })"
// CHECK-NEXT:        }
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   }
// CHECK-NEXT:  ]
// CHECK-NEXT: }


// CHECK:  "kind": "FunctionDecl", 
// CHECK-NEXT:  "loc": {
// CHECK-NEXT:   "col": 6, 
// CHECK-NEXT:   "file": "{{.*}}", 
// CHECK-NEXT:   "line": 59
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "range": {
// CHECK-NEXT:   "begin": {
// CHECK-NEXT:    "col": 1, 
// CHECK-NEXT:    "file": "{{.*}}", 
// CHECK-NEXT:    "line": 59
// CHECK-NEXT:   }, 
// CHECK-NEXT:   "end": {
// CHECK-NEXT:    "col": 1, 
// CHECK-NEXT:    "file": "{{.*}}", 
// CHECK-NEXT:    "line": 62
// CHECK-NEXT:   }
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "name": "TestObjCMessage", 
// CHECK-NEXT:  "type": {
// CHECK-NEXT:   "qualType": "void (I *)"
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "inner": [
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}", 
// CHECK-NEXT:    "kind": "ParmVarDecl", 
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 25, 
// CHECK-NEXT:     "file": "{{.*}}", 
// CHECK-NEXT:     "line": 59
// CHECK-NEXT:    }, 
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 22, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 59
// CHECK-NEXT:     }, 
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 25, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 59
// CHECK-NEXT:     }
// CHECK-NEXT:    }, 
// CHECK-NEXT:    "isUsed": true, 
// CHECK-NEXT:    "name": "Obj", 
// CHECK-NEXT:    "type": {
// CHECK-NEXT:     "qualType": "I *"
// CHECK-NEXT:    }
// CHECK-NEXT:   }, 
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}", 
// CHECK-NEXT:    "kind": "CompoundStmt", 
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 30, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 59
// CHECK-NEXT:     }, 
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 1, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 62
// CHECK-NEXT:     }
// CHECK-NEXT:    }, 
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}", 
// CHECK-NEXT:      "kind": "ObjCMessageExpr", 
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 3, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 60
// CHECK-NEXT:       }, 
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 15, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 60
// CHECK-NEXT:       }
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "void"
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "valueCategory": "rvalue", 
// CHECK-NEXT:      "selector": "method1", 
// CHECK-NEXT:      "receiverKind": "instance", 
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "ImplicitCastExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 4, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 60
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 4, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 60
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "I *"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "castKind": "LValueToRValue", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "DeclRefExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 4, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 60
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 4, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 60
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "I *"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "lvalue", 
// CHECK-NEXT:          "referencedDecl": {
// CHECK-NEXT:           "id": "0x{{.*}}", 
// CHECK-NEXT:           "kind": "ParmVarDecl", 
// CHECK-NEXT:           "name": "Obj", 
// CHECK-NEXT:           "type": {
// CHECK-NEXT:            "qualType": "I *"
// CHECK-NEXT:           }
// CHECK-NEXT:          }
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }, 
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}", 
// CHECK-NEXT:      "kind": "ObjCMessageExpr", 
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 3, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 61
// CHECK-NEXT:       }, 
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 13, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 61
// CHECK-NEXT:       }
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "void"
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "valueCategory": "rvalue", 
// CHECK-NEXT:      "selector": "method2", 
// CHECK-NEXT:      "receiverKind": "class", 
// CHECK-NEXT:      "classType": {
// CHECK-NEXT:       "qualType": "I"
// CHECK-NEXT:      }
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   }
// CHECK-NEXT:  ]
// CHECK-NEXT: }


// CHECK:  "kind": "FunctionDecl", 
// CHECK-NEXT:  "loc": {
// CHECK-NEXT:   "col": 6, 
// CHECK-NEXT:   "file": "{{.*}}", 
// CHECK-NEXT:   "line": 64
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "range": {
// CHECK-NEXT:   "begin": {
// CHECK-NEXT:    "col": 1, 
// CHECK-NEXT:    "file": "{{.*}}", 
// CHECK-NEXT:    "line": 64
// CHECK-NEXT:   }, 
// CHECK-NEXT:   "end": {
// CHECK-NEXT:    "col": 1, 
// CHECK-NEXT:    "file": "{{.*}}", 
// CHECK-NEXT:    "line": 66
// CHECK-NEXT:   }
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "name": "TestObjCBoxed", 
// CHECK-NEXT:  "type": {
// CHECK-NEXT:   "qualType": "void ()"
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "inner": [
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}", 
// CHECK-NEXT:    "kind": "CompoundStmt", 
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 22, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 64
// CHECK-NEXT:     }, 
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 1, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 66
// CHECK-NEXT:     }
// CHECK-NEXT:    }, 
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}", 
// CHECK-NEXT:      "kind": "ObjCBoxedExpr", 
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 3, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 65
// CHECK-NEXT:       }, 
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 10, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 65
// CHECK-NEXT:       }
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "NSNumber *"
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "valueCategory": "rvalue", 
// CHECK-NEXT:      "selector": "numberWithInt:", 
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "ParenExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 4, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 65
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 10, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 65
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "int"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "BinaryOperator", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 5, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 65
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 9, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 65
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "int"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "opcode": "+", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "IntegerLiteral", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 5, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 65
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 5, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 65
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "int"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "value": "1"
// CHECK-NEXT:           }, 
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "IntegerLiteral", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 9, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 65
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 9, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 65
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "int"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "value": "1"
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   }
// CHECK-NEXT:  ]
// CHECK-NEXT: }


// CHECK:  "kind": "FunctionDecl", 
// CHECK-NEXT:  "loc": {
// CHECK-NEXT:   "col": 6, 
// CHECK-NEXT:   "file": "{{.*}}", 
// CHECK-NEXT:   "line": 68
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "range": {
// CHECK-NEXT:   "begin": {
// CHECK-NEXT:    "col": 1, 
// CHECK-NEXT:    "file": "{{.*}}", 
// CHECK-NEXT:    "line": 68
// CHECK-NEXT:   }, 
// CHECK-NEXT:   "end": {
// CHECK-NEXT:    "col": 1, 
// CHECK-NEXT:    "file": "{{.*}}", 
// CHECK-NEXT:    "line": 70
// CHECK-NEXT:   }
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "name": "TestObjCSelector", 
// CHECK-NEXT:  "type": {
// CHECK-NEXT:   "qualType": "void ()"
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "inner": [
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}", 
// CHECK-NEXT:    "kind": "CompoundStmt", 
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 25, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 68
// CHECK-NEXT:     }, 
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 1, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 70
// CHECK-NEXT:     }
// CHECK-NEXT:    }, 
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}", 
// CHECK-NEXT:      "kind": "DeclStmt", 
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 3, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 69
// CHECK-NEXT:       }, 
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 29, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 69
// CHECK-NEXT:       }
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "VarDecl", 
// CHECK-NEXT:        "loc": {
// CHECK-NEXT:         "col": 7, 
// CHECK-NEXT:         "file": "{{.*}}", 
// CHECK-NEXT:         "line": 69
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 3, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 69
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 28, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 69
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "name": "s", 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "desugaredQualType": "SEL *", 
// CHECK-NEXT:         "qualType": "SEL"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "init": "c", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "ObjCSelectorExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 11, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 69
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 28, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 69
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "desugaredQualType": "SEL *", 
// CHECK-NEXT:           "qualType": "SEL"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "selector": "dealloc"
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   }
// CHECK-NEXT:  ]
// CHECK-NEXT: }


// CHECK:  "kind": "FunctionDecl", 
// CHECK-NEXT:  "loc": {
// CHECK-NEXT:   "col": 6, 
// CHECK-NEXT:   "file": "{{.*}}", 
// CHECK-NEXT:   "line": 72
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "range": {
// CHECK-NEXT:   "begin": {
// CHECK-NEXT:    "col": 1, 
// CHECK-NEXT:    "file": "{{.*}}", 
// CHECK-NEXT:    "line": 72
// CHECK-NEXT:   }, 
// CHECK-NEXT:   "end": {
// CHECK-NEXT:    "col": 1, 
// CHECK-NEXT:    "file": "{{.*}}", 
// CHECK-NEXT:    "line": 74
// CHECK-NEXT:   }
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "name": "TestObjCProtocol", 
// CHECK-NEXT:  "type": {
// CHECK-NEXT:   "qualType": "void (id)"
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "inner": [
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}", 
// CHECK-NEXT:    "kind": "ParmVarDecl", 
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 26, 
// CHECK-NEXT:     "file": "{{.*}}", 
// CHECK-NEXT:     "line": 72
// CHECK-NEXT:    }, 
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 23, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 72
// CHECK-NEXT:     }, 
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 26, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 72
// CHECK-NEXT:     }
// CHECK-NEXT:    }, 
// CHECK-NEXT:    "isUsed": true, 
// CHECK-NEXT:    "name": "Obj", 
// CHECK-NEXT:    "type": {
// CHECK-NEXT:     "desugaredQualType": "id", 
// CHECK-NEXT:     "qualType": "id"
// CHECK-NEXT:    }
// CHECK-NEXT:   }, 
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}", 
// CHECK-NEXT:    "kind": "CompoundStmt", 
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 31, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 72
// CHECK-NEXT:     }, 
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 1, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 74
// CHECK-NEXT:     }
// CHECK-NEXT:    }, 
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}", 
// CHECK-NEXT:      "kind": "ObjCMessageExpr", 
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 3, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 73
// CHECK-NEXT:       }, 
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 43, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 73
// CHECK-NEXT:       }
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "int"
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "valueCategory": "rvalue", 
// CHECK-NEXT:      "selector": "conformsToProtocol:", 
// CHECK-NEXT:      "receiverKind": "instance", 
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "ImplicitCastExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 4, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 73
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 4, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 73
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "desugaredQualType": "id", 
// CHECK-NEXT:         "qualType": "id"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "castKind": "LValueToRValue", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "DeclRefExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 4, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 73
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 4, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 73
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "desugaredQualType": "id", 
// CHECK-NEXT:           "qualType": "id"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "lvalue", 
// CHECK-NEXT:          "referencedDecl": {
// CHECK-NEXT:           "id": "0x{{.*}}", 
// CHECK-NEXT:           "kind": "ParmVarDecl", 
// CHECK-NEXT:           "name": "Obj", 
// CHECK-NEXT:           "type": {
// CHECK-NEXT:            "desugaredQualType": "id", 
// CHECK-NEXT:            "qualType": "id"
// CHECK-NEXT:           }
// CHECK-NEXT:          }
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }, 
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "ObjCProtocolExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 27, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 73
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 42, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 73
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "Protocol *"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "protocol": {
// CHECK-NEXT:         "id": "0x{{.*}}", 
// CHECK-NEXT:         "kind": "ObjCProtocolDecl", 
// CHECK-NEXT:         "name": "Proto"
// CHECK-NEXT:        }
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   }
// CHECK-NEXT:  ]
// CHECK-NEXT: }


// CHECK:  "kind": "FunctionDecl", 
// CHECK-NEXT:  "loc": {
// CHECK-NEXT:   "col": 6, 
// CHECK-NEXT:   "file": "{{.*}}", 
// CHECK-NEXT:   "line": 76
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "range": {
// CHECK-NEXT:   "begin": {
// CHECK-NEXT:    "col": 1, 
// CHECK-NEXT:    "file": "{{.*}}", 
// CHECK-NEXT:    "line": 76
// CHECK-NEXT:   }, 
// CHECK-NEXT:   "end": {
// CHECK-NEXT:    "col": 1, 
// CHECK-NEXT:    "file": "{{.*}}", 
// CHECK-NEXT:    "line": 79
// CHECK-NEXT:   }
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "name": "TestObjCPropertyRef", 
// CHECK-NEXT:  "type": {
// CHECK-NEXT:   "qualType": "void (J *)"
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "inner": [
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}", 
// CHECK-NEXT:    "kind": "ParmVarDecl", 
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 29, 
// CHECK-NEXT:     "file": "{{.*}}", 
// CHECK-NEXT:     "line": 76
// CHECK-NEXT:    }, 
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 26, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 76
// CHECK-NEXT:     }, 
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 29, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 76
// CHECK-NEXT:     }
// CHECK-NEXT:    }, 
// CHECK-NEXT:    "isUsed": true, 
// CHECK-NEXT:    "name": "Obj", 
// CHECK-NEXT:    "type": {
// CHECK-NEXT:     "qualType": "J *"
// CHECK-NEXT:    }
// CHECK-NEXT:   }, 
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}", 
// CHECK-NEXT:    "kind": "CompoundStmt", 
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 34, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 76
// CHECK-NEXT:     }, 
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 1, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 79
// CHECK-NEXT:     }
// CHECK-NEXT:    }, 
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}", 
// CHECK-NEXT:      "kind": "PseudoObjectExpr", 
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 3, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 77
// CHECK-NEXT:       }, 
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 14, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 77
// CHECK-NEXT:       }
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "unsigned int"
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "valueCategory": "rvalue", 
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "BinaryOperator", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 3, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 77
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 14, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 77
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "int"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "opcode": "=", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "ObjCPropertyRefExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 3, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 77
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 7, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 77
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "<pseudo-object type>"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "lvalue", 
// CHECK-NEXT:          "propertyKind": "explicit", 
// CHECK-NEXT:          "property": {
// CHECK-NEXT:           "id": "0x{{.*}}", 
// CHECK-NEXT:           "kind": "ObjCPropertyDecl", 
// CHECK-NEXT:           "name": "prop"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "isMessagingSetter": true, 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "OpaqueValueExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 3, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 77
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 3, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 77
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "J *"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "ImplicitCastExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 3, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 77
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 3, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 77
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "J *"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "castKind": "LValueToRValue", 
// CHECK-NEXT:              "inner": [
// CHECK-NEXT:               {
// CHECK-NEXT:                "id": "0x{{.*}}", 
// CHECK-NEXT:                "kind": "DeclRefExpr", 
// CHECK-NEXT:                "range": {
// CHECK-NEXT:                 "begin": {
// CHECK-NEXT:                  "col": 3, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 77
// CHECK-NEXT:                 }, 
// CHECK-NEXT:                 "end": {
// CHECK-NEXT:                  "col": 3, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 77
// CHECK-NEXT:                 }
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "type": {
// CHECK-NEXT:                 "qualType": "J *"
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "valueCategory": "lvalue", 
// CHECK-NEXT:                "referencedDecl": {
// CHECK-NEXT:                 "id": "0x{{.*}}", 
// CHECK-NEXT:                 "kind": "ParmVarDecl", 
// CHECK-NEXT:                 "name": "Obj", 
// CHECK-NEXT:                 "type": {
// CHECK-NEXT:                  "qualType": "J *"
// CHECK-NEXT:                 }
// CHECK-NEXT:                }
// CHECK-NEXT:               }
// CHECK-NEXT:              ]
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }, 
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "OpaqueValueExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 14, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 77
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 14, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 77
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "int"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "IntegerLiteral", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 14, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 77
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 14, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 77
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "int"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "value": "12"
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }, 
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "OpaqueValueExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 3, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 77
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 3, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 77
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "J *"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "ImplicitCastExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 3, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 77
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 3, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 77
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "J *"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "castKind": "LValueToRValue", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "DeclRefExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 3, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 77
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 3, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 77
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "J *"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "lvalue", 
// CHECK-NEXT:            "referencedDecl": {
// CHECK-NEXT:             "id": "0x{{.*}}", 
// CHECK-NEXT:             "kind": "ParmVarDecl", 
// CHECK-NEXT:             "name": "Obj", 
// CHECK-NEXT:             "type": {
// CHECK-NEXT:              "qualType": "J *"
// CHECK-NEXT:             }
// CHECK-NEXT:            }
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }, 
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "OpaqueValueExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 14, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 77
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 14, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 77
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "int"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "IntegerLiteral", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 14, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 77
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 14, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 77
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "int"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "value": "12"
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }, 
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "OpaqueValueExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 14, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 77
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 14, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 77
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "unsigned int"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "ImplicitCastExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 14, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 77
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 14, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 77
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "unsigned int"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "castKind": "IntegralCast", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "OpaqueValueExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 14, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 77
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 14, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 77
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "int"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "IntegerLiteral", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 14, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 77
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 14, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 77
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "int"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "value": "12"
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }, 
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "ObjCMessageExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 7, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 77
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 7, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 77
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "void"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "selector": "setProp:", 
// CHECK-NEXT:        "receiverKind": "instance", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "OpaqueValueExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 3, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 77
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 3, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 77
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "J *"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "ImplicitCastExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 3, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 77
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 3, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 77
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "J *"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "castKind": "LValueToRValue", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "DeclRefExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 3, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 77
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 3, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 77
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "J *"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "lvalue", 
// CHECK-NEXT:              "referencedDecl": {
// CHECK-NEXT:               "id": "0x{{.*}}", 
// CHECK-NEXT:               "kind": "ParmVarDecl", 
// CHECK-NEXT:               "name": "Obj", 
// CHECK-NEXT:               "type": {
// CHECK-NEXT:                "qualType": "J *"
// CHECK-NEXT:               }
// CHECK-NEXT:              }
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }, 
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "OpaqueValueExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 14, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 77
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 14, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 77
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "unsigned int"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "ImplicitCastExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 14, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 77
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 14, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 77
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "unsigned int"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "castKind": "IntegralCast", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "OpaqueValueExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 14, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 77
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 14, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 77
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "int"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "inner": [
// CHECK-NEXT:               {
// CHECK-NEXT:                "id": "0x{{.*}}", 
// CHECK-NEXT:                "kind": "IntegerLiteral", 
// CHECK-NEXT:                "range": {
// CHECK-NEXT:                 "begin": {
// CHECK-NEXT:                  "col": 14, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 77
// CHECK-NEXT:                 }, 
// CHECK-NEXT:                 "end": {
// CHECK-NEXT:                  "col": 14, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 77
// CHECK-NEXT:                 }
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "type": {
// CHECK-NEXT:                 "qualType": "int"
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "valueCategory": "rvalue", 
// CHECK-NEXT:                "value": "12"
// CHECK-NEXT:               }
// CHECK-NEXT:              ]
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }, 
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}", 
// CHECK-NEXT:      "kind": "DeclStmt", 
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 3, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 78
// CHECK-NEXT:       }, 
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 19, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 78
// CHECK-NEXT:       }
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "VarDecl", 
// CHECK-NEXT:        "loc": {
// CHECK-NEXT:         "col": 7, 
// CHECK-NEXT:         "file": "{{.*}}", 
// CHECK-NEXT:         "line": 78
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 3, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 78
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 15, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 78
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "name": "i", 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "int"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "init": "c", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "ImplicitCastExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 11, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 78
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 15, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 78
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "int"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "castKind": "IntegralCast", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "PseudoObjectExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 11, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 78
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 15, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 78
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "unsigned int"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "ObjCPropertyRefExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 11, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 78
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 15, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 78
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "<pseudo-object type>"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "lvalue", 
// CHECK-NEXT:              "propertyKind": "explicit", 
// CHECK-NEXT:              "property": {
// CHECK-NEXT:               "id": "0x{{.*}}", 
// CHECK-NEXT:               "kind": "ObjCPropertyDecl", 
// CHECK-NEXT:               "name": "prop"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "isMessagingGetter": true, 
// CHECK-NEXT:              "inner": [
// CHECK-NEXT:               {
// CHECK-NEXT:                "id": "0x{{.*}}", 
// CHECK-NEXT:                "kind": "OpaqueValueExpr", 
// CHECK-NEXT:                "range": {
// CHECK-NEXT:                 "begin": {
// CHECK-NEXT:                  "col": 11, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 78
// CHECK-NEXT:                 }, 
// CHECK-NEXT:                 "end": {
// CHECK-NEXT:                  "col": 11, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 78
// CHECK-NEXT:                 }
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "type": {
// CHECK-NEXT:                 "qualType": "J *"
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "valueCategory": "rvalue", 
// CHECK-NEXT:                "inner": [
// CHECK-NEXT:                 {
// CHECK-NEXT:                  "id": "0x{{.*}}", 
// CHECK-NEXT:                  "kind": "ImplicitCastExpr", 
// CHECK-NEXT:                  "range": {
// CHECK-NEXT:                   "begin": {
// CHECK-NEXT:                    "col": 11, 
// CHECK-NEXT:                    "file": "{{.*}}", 
// CHECK-NEXT:                    "line": 78
// CHECK-NEXT:                   }, 
// CHECK-NEXT:                   "end": {
// CHECK-NEXT:                    "col": 11, 
// CHECK-NEXT:                    "file": "{{.*}}", 
// CHECK-NEXT:                    "line": 78
// CHECK-NEXT:                   }
// CHECK-NEXT:                  }, 
// CHECK-NEXT:                  "type": {
// CHECK-NEXT:                   "qualType": "J *"
// CHECK-NEXT:                  }, 
// CHECK-NEXT:                  "valueCategory": "rvalue", 
// CHECK-NEXT:                  "castKind": "LValueToRValue", 
// CHECK-NEXT:                  "inner": [
// CHECK-NEXT:                   {
// CHECK-NEXT:                    "id": "0x{{.*}}", 
// CHECK-NEXT:                    "kind": "DeclRefExpr", 
// CHECK-NEXT:                    "range": {
// CHECK-NEXT:                     "begin": {
// CHECK-NEXT:                      "col": 11, 
// CHECK-NEXT:                      "file": "{{.*}}", 
// CHECK-NEXT:                      "line": 78
// CHECK-NEXT:                     }, 
// CHECK-NEXT:                     "end": {
// CHECK-NEXT:                      "col": 11, 
// CHECK-NEXT:                      "file": "{{.*}}", 
// CHECK-NEXT:                      "line": 78
// CHECK-NEXT:                     }
// CHECK-NEXT:                    }, 
// CHECK-NEXT:                    "type": {
// CHECK-NEXT:                     "qualType": "J *"
// CHECK-NEXT:                    }, 
// CHECK-NEXT:                    "valueCategory": "lvalue", 
// CHECK-NEXT:                    "referencedDecl": {
// CHECK-NEXT:                     "id": "0x{{.*}}", 
// CHECK-NEXT:                     "kind": "ParmVarDecl", 
// CHECK-NEXT:                     "name": "Obj", 
// CHECK-NEXT:                     "type": {
// CHECK-NEXT:                      "qualType": "J *"
// CHECK-NEXT:                     }
// CHECK-NEXT:                    }
// CHECK-NEXT:                   }
// CHECK-NEXT:                  ]
// CHECK-NEXT:                 }
// CHECK-NEXT:                ]
// CHECK-NEXT:               }
// CHECK-NEXT:              ]
// CHECK-NEXT:             }, 
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "OpaqueValueExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 11, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 78
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 11, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 78
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "J *"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "inner": [
// CHECK-NEXT:               {
// CHECK-NEXT:                "id": "0x{{.*}}", 
// CHECK-NEXT:                "kind": "ImplicitCastExpr", 
// CHECK-NEXT:                "range": {
// CHECK-NEXT:                 "begin": {
// CHECK-NEXT:                  "col": 11, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 78
// CHECK-NEXT:                 }, 
// CHECK-NEXT:                 "end": {
// CHECK-NEXT:                  "col": 11, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 78
// CHECK-NEXT:                 }
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "type": {
// CHECK-NEXT:                 "qualType": "J *"
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "valueCategory": "rvalue", 
// CHECK-NEXT:                "castKind": "LValueToRValue", 
// CHECK-NEXT:                "inner": [
// CHECK-NEXT:                 {
// CHECK-NEXT:                  "id": "0x{{.*}}", 
// CHECK-NEXT:                  "kind": "DeclRefExpr", 
// CHECK-NEXT:                  "range": {
// CHECK-NEXT:                   "begin": {
// CHECK-NEXT:                    "col": 11, 
// CHECK-NEXT:                    "file": "{{.*}}", 
// CHECK-NEXT:                    "line": 78
// CHECK-NEXT:                   }, 
// CHECK-NEXT:                   "end": {
// CHECK-NEXT:                    "col": 11, 
// CHECK-NEXT:                    "file": "{{.*}}", 
// CHECK-NEXT:                    "line": 78
// CHECK-NEXT:                   }
// CHECK-NEXT:                  }, 
// CHECK-NEXT:                  "type": {
// CHECK-NEXT:                   "qualType": "J *"
// CHECK-NEXT:                  }, 
// CHECK-NEXT:                  "valueCategory": "lvalue", 
// CHECK-NEXT:                  "referencedDecl": {
// CHECK-NEXT:                   "id": "0x{{.*}}", 
// CHECK-NEXT:                   "kind": "ParmVarDecl", 
// CHECK-NEXT:                   "name": "Obj", 
// CHECK-NEXT:                   "type": {
// CHECK-NEXT:                    "qualType": "J *"
// CHECK-NEXT:                   }
// CHECK-NEXT:                  }
// CHECK-NEXT:                 }
// CHECK-NEXT:                ]
// CHECK-NEXT:               }
// CHECK-NEXT:              ]
// CHECK-NEXT:             }, 
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "ObjCMessageExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 15, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 78
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 15, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 78
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "unsigned int"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "selector": "prop", 
// CHECK-NEXT:              "receiverKind": "instance", 
// CHECK-NEXT:              "inner": [
// CHECK-NEXT:               {
// CHECK-NEXT:                "id": "0x{{.*}}", 
// CHECK-NEXT:                "kind": "OpaqueValueExpr", 
// CHECK-NEXT:                "range": {
// CHECK-NEXT:                 "begin": {
// CHECK-NEXT:                  "col": 11, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 78
// CHECK-NEXT:                 }, 
// CHECK-NEXT:                 "end": {
// CHECK-NEXT:                  "col": 11, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 78
// CHECK-NEXT:                 }
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "type": {
// CHECK-NEXT:                 "qualType": "J *"
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "valueCategory": "rvalue", 
// CHECK-NEXT:                "inner": [
// CHECK-NEXT:                 {
// CHECK-NEXT:                  "id": "0x{{.*}}", 
// CHECK-NEXT:                  "kind": "ImplicitCastExpr", 
// CHECK-NEXT:                  "range": {
// CHECK-NEXT:                   "begin": {
// CHECK-NEXT:                    "col": 11, 
// CHECK-NEXT:                    "file": "{{.*}}", 
// CHECK-NEXT:                    "line": 78
// CHECK-NEXT:                   }, 
// CHECK-NEXT:                   "end": {
// CHECK-NEXT:                    "col": 11, 
// CHECK-NEXT:                    "file": "{{.*}}", 
// CHECK-NEXT:                    "line": 78
// CHECK-NEXT:                   }
// CHECK-NEXT:                  }, 
// CHECK-NEXT:                  "type": {
// CHECK-NEXT:                   "qualType": "J *"
// CHECK-NEXT:                  }, 
// CHECK-NEXT:                  "valueCategory": "rvalue", 
// CHECK-NEXT:                  "castKind": "LValueToRValue", 
// CHECK-NEXT:                  "inner": [
// CHECK-NEXT:                   {
// CHECK-NEXT:                    "id": "0x{{.*}}", 
// CHECK-NEXT:                    "kind": "DeclRefExpr", 
// CHECK-NEXT:                    "range": {
// CHECK-NEXT:                     "begin": {
// CHECK-NEXT:                      "col": 11, 
// CHECK-NEXT:                      "file": "{{.*}}", 
// CHECK-NEXT:                      "line": 78
// CHECK-NEXT:                     }, 
// CHECK-NEXT:                     "end": {
// CHECK-NEXT:                      "col": 11, 
// CHECK-NEXT:                      "file": "{{.*}}", 
// CHECK-NEXT:                      "line": 78
// CHECK-NEXT:                     }
// CHECK-NEXT:                    }, 
// CHECK-NEXT:                    "type": {
// CHECK-NEXT:                     "qualType": "J *"
// CHECK-NEXT:                    }, 
// CHECK-NEXT:                    "valueCategory": "lvalue", 
// CHECK-NEXT:                    "referencedDecl": {
// CHECK-NEXT:                     "id": "0x{{.*}}", 
// CHECK-NEXT:                     "kind": "ParmVarDecl", 
// CHECK-NEXT:                     "name": "Obj", 
// CHECK-NEXT:                     "type": {
// CHECK-NEXT:                      "qualType": "J *"
// CHECK-NEXT:                     }
// CHECK-NEXT:                    }
// CHECK-NEXT:                   }
// CHECK-NEXT:                  ]
// CHECK-NEXT:                 }
// CHECK-NEXT:                ]
// CHECK-NEXT:               }
// CHECK-NEXT:              ]
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   }
// CHECK-NEXT:  ]
// CHECK-NEXT: }


// CHECK:  "kind": "FunctionDecl", 
// CHECK-NEXT:  "loc": {
// CHECK-NEXT:   "col": 6, 
// CHECK-NEXT:   "file": "{{.*}}", 
// CHECK-NEXT:   "line": 81
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "range": {
// CHECK-NEXT:   "begin": {
// CHECK-NEXT:    "col": 1, 
// CHECK-NEXT:    "file": "{{.*}}", 
// CHECK-NEXT:    "line": 81
// CHECK-NEXT:   }, 
// CHECK-NEXT:   "end": {
// CHECK-NEXT:    "col": 1, 
// CHECK-NEXT:    "file": "{{.*}}", 
// CHECK-NEXT:    "line": 87
// CHECK-NEXT:   }
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "name": "TestObjCSubscriptRef", 
// CHECK-NEXT:  "type": {
// CHECK-NEXT:   "qualType": "void (NSMutableArray *, NSMutableDictionary *)"
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "inner": [
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}", 
// CHECK-NEXT:    "kind": "ParmVarDecl", 
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 43, 
// CHECK-NEXT:     "file": "{{.*}}", 
// CHECK-NEXT:     "line": 81
// CHECK-NEXT:    }, 
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 27, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 81
// CHECK-NEXT:     }, 
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 43, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 81
// CHECK-NEXT:     }
// CHECK-NEXT:    }, 
// CHECK-NEXT:    "isUsed": true, 
// CHECK-NEXT:    "name": "Array", 
// CHECK-NEXT:    "type": {
// CHECK-NEXT:     "qualType": "NSMutableArray *"
// CHECK-NEXT:    }
// CHECK-NEXT:   }, 
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}", 
// CHECK-NEXT:    "kind": "ParmVarDecl", 
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 71, 
// CHECK-NEXT:     "file": "{{.*}}", 
// CHECK-NEXT:     "line": 81
// CHECK-NEXT:    }, 
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 50, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 81
// CHECK-NEXT:     }, 
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 71, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 81
// CHECK-NEXT:     }
// CHECK-NEXT:    }, 
// CHECK-NEXT:    "isUsed": true, 
// CHECK-NEXT:    "name": "Dict", 
// CHECK-NEXT:    "type": {
// CHECK-NEXT:     "qualType": "NSMutableDictionary *"
// CHECK-NEXT:    }
// CHECK-NEXT:   }, 
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}", 
// CHECK-NEXT:    "kind": "CompoundStmt", 
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 77, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 81
// CHECK-NEXT:     }, 
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 1, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 87
// CHECK-NEXT:     }
// CHECK-NEXT:    }, 
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}", 
// CHECK-NEXT:      "kind": "PseudoObjectExpr", 
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 2, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 82
// CHECK-NEXT:       }, 
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 20, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 82
// CHECK-NEXT:       }
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "desugaredQualType": "id", 
// CHECK-NEXT:       "qualType": "id"
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "valueCategory": "rvalue", 
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "BinaryOperator", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 2, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 82
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 20, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 82
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "void *"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "opcode": "=", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "ObjCSubscriptRefExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 2, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 82
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 9, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 82
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "<pseudo-object type>"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "lvalue", 
// CHECK-NEXT:          "subscriptKind": "array", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "OpaqueValueExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 2, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 82
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 2, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 82
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "NSMutableArray *"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "ImplicitCastExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 2, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 82
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 2, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 82
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "NSMutableArray *"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "castKind": "LValueToRValue", 
// CHECK-NEXT:              "inner": [
// CHECK-NEXT:               {
// CHECK-NEXT:                "id": "0x{{.*}}", 
// CHECK-NEXT:                "kind": "DeclRefExpr", 
// CHECK-NEXT:                "range": {
// CHECK-NEXT:                 "begin": {
// CHECK-NEXT:                  "col": 2, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 82
// CHECK-NEXT:                 }, 
// CHECK-NEXT:                 "end": {
// CHECK-NEXT:                  "col": 2, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 82
// CHECK-NEXT:                 }
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "type": {
// CHECK-NEXT:                 "qualType": "NSMutableArray *"
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "valueCategory": "lvalue", 
// CHECK-NEXT:                "referencedDecl": {
// CHECK-NEXT:                 "id": "0x{{.*}}", 
// CHECK-NEXT:                 "kind": "ParmVarDecl", 
// CHECK-NEXT:                 "name": "Array", 
// CHECK-NEXT:                 "type": {
// CHECK-NEXT:                  "qualType": "NSMutableArray *"
// CHECK-NEXT:                 }
// CHECK-NEXT:                }
// CHECK-NEXT:               }
// CHECK-NEXT:              ]
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }, 
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "OpaqueValueExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 8, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 82
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 8, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 82
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "int"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "IntegerLiteral", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 8, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 82
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 8, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 82
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "int"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "value": "0"
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }, 
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "OpaqueValueExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 13, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 82
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 20, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 82
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "void *"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "CStyleCastExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 13, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 82
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 20, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 82
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "void *"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "castKind": "NullToPointer", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "IntegerLiteral", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 20, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 82
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 20, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 82
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "int"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "value": "0"
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }, 
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "OpaqueValueExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 2, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 82
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 2, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 82
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "NSMutableArray *"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "ImplicitCastExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 2, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 82
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 2, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 82
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "NSMutableArray *"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "castKind": "LValueToRValue", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "DeclRefExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 2, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 82
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 2, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 82
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "NSMutableArray *"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "lvalue", 
// CHECK-NEXT:            "referencedDecl": {
// CHECK-NEXT:             "id": "0x{{.*}}", 
// CHECK-NEXT:             "kind": "ParmVarDecl", 
// CHECK-NEXT:             "name": "Array", 
// CHECK-NEXT:             "type": {
// CHECK-NEXT:              "qualType": "NSMutableArray *"
// CHECK-NEXT:             }
// CHECK-NEXT:            }
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }, 
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "OpaqueValueExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 8, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 82
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 8, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 82
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "int"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "IntegerLiteral", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 8, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 82
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 8, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 82
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "int"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "value": "0"
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }, 
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "OpaqueValueExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 13, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 82
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 20, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 82
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "void *"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "CStyleCastExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 13, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 82
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 20, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 82
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "void *"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "castKind": "NullToPointer", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "IntegerLiteral", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 20, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 82
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 20, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 82
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "int"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "value": "0"
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }, 
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "OpaqueValueExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 13, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 82
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 20, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 82
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "desugaredQualType": "id", 
// CHECK-NEXT:         "qualType": "id"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "ImplicitCastExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 13, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 82
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 20, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 82
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "desugaredQualType": "id", 
// CHECK-NEXT:           "qualType": "id"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "castKind": "NullToPointer", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "OpaqueValueExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 13, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 82
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 20, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 82
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "void *"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "CStyleCastExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 13, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 82
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 20, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 82
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "void *"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "castKind": "NullToPointer", 
// CHECK-NEXT:              "inner": [
// CHECK-NEXT:               {
// CHECK-NEXT:                "id": "0x{{.*}}", 
// CHECK-NEXT:                "kind": "IntegerLiteral", 
// CHECK-NEXT:                "range": {
// CHECK-NEXT:                 "begin": {
// CHECK-NEXT:                  "col": 20, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 82
// CHECK-NEXT:                 }, 
// CHECK-NEXT:                 "end": {
// CHECK-NEXT:                  "col": 20, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 82
// CHECK-NEXT:                 }
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "type": {
// CHECK-NEXT:                 "qualType": "int"
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "valueCategory": "rvalue", 
// CHECK-NEXT:                "value": "0"
// CHECK-NEXT:               }
// CHECK-NEXT:              ]
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }, 
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "ObjCMessageExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 2, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 82
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 2, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 82
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "void"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "selector": "setObject:atIndexedSubscript:", 
// CHECK-NEXT:        "receiverKind": "instance", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "OpaqueValueExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 2, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 82
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 2, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 82
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "NSMutableArray *"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "ImplicitCastExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 2, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 82
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 2, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 82
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "NSMutableArray *"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "castKind": "LValueToRValue", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "DeclRefExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 2, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 82
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 2, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 82
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "NSMutableArray *"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "lvalue", 
// CHECK-NEXT:              "referencedDecl": {
// CHECK-NEXT:               "id": "0x{{.*}}", 
// CHECK-NEXT:               "kind": "ParmVarDecl", 
// CHECK-NEXT:               "name": "Array", 
// CHECK-NEXT:               "type": {
// CHECK-NEXT:                "qualType": "NSMutableArray *"
// CHECK-NEXT:               }
// CHECK-NEXT:              }
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }, 
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "OpaqueValueExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 13, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 82
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 20, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 82
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "desugaredQualType": "id", 
// CHECK-NEXT:           "qualType": "id"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "ImplicitCastExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 13, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 82
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 20, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 82
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "desugaredQualType": "id", 
// CHECK-NEXT:             "qualType": "id"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "castKind": "NullToPointer", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "OpaqueValueExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 13, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 82
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 20, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 82
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "void *"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "inner": [
// CHECK-NEXT:               {
// CHECK-NEXT:                "id": "0x{{.*}}", 
// CHECK-NEXT:                "kind": "CStyleCastExpr", 
// CHECK-NEXT:                "range": {
// CHECK-NEXT:                 "begin": {
// CHECK-NEXT:                  "col": 13, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 82
// CHECK-NEXT:                 }, 
// CHECK-NEXT:                 "end": {
// CHECK-NEXT:                  "col": 20, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 82
// CHECK-NEXT:                 }
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "type": {
// CHECK-NEXT:                 "qualType": "void *"
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "valueCategory": "rvalue", 
// CHECK-NEXT:                "castKind": "NullToPointer", 
// CHECK-NEXT:                "inner": [
// CHECK-NEXT:                 {
// CHECK-NEXT:                  "id": "0x{{.*}}", 
// CHECK-NEXT:                  "kind": "IntegerLiteral", 
// CHECK-NEXT:                  "range": {
// CHECK-NEXT:                   "begin": {
// CHECK-NEXT:                    "col": 20, 
// CHECK-NEXT:                    "file": "{{.*}}", 
// CHECK-NEXT:                    "line": 82
// CHECK-NEXT:                   }, 
// CHECK-NEXT:                   "end": {
// CHECK-NEXT:                    "col": 20, 
// CHECK-NEXT:                    "file": "{{.*}}", 
// CHECK-NEXT:                    "line": 82
// CHECK-NEXT:                   }
// CHECK-NEXT:                  }, 
// CHECK-NEXT:                  "type": {
// CHECK-NEXT:                   "qualType": "int"
// CHECK-NEXT:                  }, 
// CHECK-NEXT:                  "valueCategory": "rvalue", 
// CHECK-NEXT:                  "value": "0"
// CHECK-NEXT:                 }
// CHECK-NEXT:                ]
// CHECK-NEXT:               }
// CHECK-NEXT:              ]
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }, 
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "OpaqueValueExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 8, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 82
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 8, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 82
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "int"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "IntegerLiteral", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 8, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 82
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 8, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 82
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "int"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "value": "0"
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }, 
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}", 
// CHECK-NEXT:      "kind": "DeclStmt", 
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 2, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 83
// CHECK-NEXT:       }, 
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 17, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 83
// CHECK-NEXT:       }
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "VarDecl", 
// CHECK-NEXT:        "loc": {
// CHECK-NEXT:         "col": 5, 
// CHECK-NEXT:         "file": "{{.*}}", 
// CHECK-NEXT:         "line": 83
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 2, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 83
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 16, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 83
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "isUsed": true, 
// CHECK-NEXT:        "name": "i", 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "desugaredQualType": "id", 
// CHECK-NEXT:         "qualType": "id"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "init": "c", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "PseudoObjectExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 9, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 83
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 16, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 83
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "desugaredQualType": "id", 
// CHECK-NEXT:           "qualType": "id"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "ObjCSubscriptRefExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 9, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 83
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 16, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 83
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "<pseudo-object type>"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "lvalue", 
// CHECK-NEXT:            "subscriptKind": "array", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "OpaqueValueExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 9, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 83
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 9, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 83
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "NSMutableArray *"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "inner": [
// CHECK-NEXT:               {
// CHECK-NEXT:                "id": "0x{{.*}}", 
// CHECK-NEXT:                "kind": "ImplicitCastExpr", 
// CHECK-NEXT:                "range": {
// CHECK-NEXT:                 "begin": {
// CHECK-NEXT:                  "col": 9, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 83
// CHECK-NEXT:                 }, 
// CHECK-NEXT:                 "end": {
// CHECK-NEXT:                  "col": 9, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 83
// CHECK-NEXT:                 }
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "type": {
// CHECK-NEXT:                 "qualType": "NSMutableArray *"
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "valueCategory": "rvalue", 
// CHECK-NEXT:                "castKind": "LValueToRValue", 
// CHECK-NEXT:                "inner": [
// CHECK-NEXT:                 {
// CHECK-NEXT:                  "id": "0x{{.*}}", 
// CHECK-NEXT:                  "kind": "DeclRefExpr", 
// CHECK-NEXT:                  "range": {
// CHECK-NEXT:                   "begin": {
// CHECK-NEXT:                    "col": 9, 
// CHECK-NEXT:                    "file": "{{.*}}", 
// CHECK-NEXT:                    "line": 83
// CHECK-NEXT:                   }, 
// CHECK-NEXT:                   "end": {
// CHECK-NEXT:                    "col": 9, 
// CHECK-NEXT:                    "file": "{{.*}}", 
// CHECK-NEXT:                    "line": 83
// CHECK-NEXT:                   }
// CHECK-NEXT:                  }, 
// CHECK-NEXT:                  "type": {
// CHECK-NEXT:                   "qualType": "NSMutableArray *"
// CHECK-NEXT:                  }, 
// CHECK-NEXT:                  "valueCategory": "lvalue", 
// CHECK-NEXT:                  "referencedDecl": {
// CHECK-NEXT:                   "id": "0x{{.*}}", 
// CHECK-NEXT:                   "kind": "ParmVarDecl", 
// CHECK-NEXT:                   "name": "Array", 
// CHECK-NEXT:                   "type": {
// CHECK-NEXT:                    "qualType": "NSMutableArray *"
// CHECK-NEXT:                   }
// CHECK-NEXT:                  }
// CHECK-NEXT:                 }
// CHECK-NEXT:                ]
// CHECK-NEXT:               }
// CHECK-NEXT:              ]
// CHECK-NEXT:             }, 
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "OpaqueValueExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 15, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 83
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 15, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 83
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "int"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "inner": [
// CHECK-NEXT:               {
// CHECK-NEXT:                "id": "0x{{.*}}", 
// CHECK-NEXT:                "kind": "IntegerLiteral", 
// CHECK-NEXT:                "range": {
// CHECK-NEXT:                 "begin": {
// CHECK-NEXT:                  "col": 15, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 83
// CHECK-NEXT:                 }, 
// CHECK-NEXT:                 "end": {
// CHECK-NEXT:                  "col": 15, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 83
// CHECK-NEXT:                 }
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "type": {
// CHECK-NEXT:                 "qualType": "int"
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "valueCategory": "rvalue", 
// CHECK-NEXT:                "value": "0"
// CHECK-NEXT:               }
// CHECK-NEXT:              ]
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }, 
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "OpaqueValueExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 9, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 83
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 9, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 83
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "NSMutableArray *"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "ImplicitCastExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 9, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 83
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 9, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 83
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "NSMutableArray *"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "castKind": "LValueToRValue", 
// CHECK-NEXT:              "inner": [
// CHECK-NEXT:               {
// CHECK-NEXT:                "id": "0x{{.*}}", 
// CHECK-NEXT:                "kind": "DeclRefExpr", 
// CHECK-NEXT:                "range": {
// CHECK-NEXT:                 "begin": {
// CHECK-NEXT:                  "col": 9, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 83
// CHECK-NEXT:                 }, 
// CHECK-NEXT:                 "end": {
// CHECK-NEXT:                  "col": 9, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 83
// CHECK-NEXT:                 }
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "type": {
// CHECK-NEXT:                 "qualType": "NSMutableArray *"
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "valueCategory": "lvalue", 
// CHECK-NEXT:                "referencedDecl": {
// CHECK-NEXT:                 "id": "0x{{.*}}", 
// CHECK-NEXT:                 "kind": "ParmVarDecl", 
// CHECK-NEXT:                 "name": "Array", 
// CHECK-NEXT:                 "type": {
// CHECK-NEXT:                  "qualType": "NSMutableArray *"
// CHECK-NEXT:                 }
// CHECK-NEXT:                }
// CHECK-NEXT:               }
// CHECK-NEXT:              ]
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }, 
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "OpaqueValueExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 15, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 83
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 15, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 83
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "int"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "IntegerLiteral", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 15, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 83
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 15, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 83
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "int"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "value": "0"
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }, 
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "ObjCMessageExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 9, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 83
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 9, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 83
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "desugaredQualType": "id", 
// CHECK-NEXT:             "qualType": "id"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "selector": "objectAtIndexedSubscript:", 
// CHECK-NEXT:            "receiverKind": "instance", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "OpaqueValueExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 9, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 83
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 9, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 83
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "NSMutableArray *"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "inner": [
// CHECK-NEXT:               {
// CHECK-NEXT:                "id": "0x{{.*}}", 
// CHECK-NEXT:                "kind": "ImplicitCastExpr", 
// CHECK-NEXT:                "range": {
// CHECK-NEXT:                 "begin": {
// CHECK-NEXT:                  "col": 9, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 83
// CHECK-NEXT:                 }, 
// CHECK-NEXT:                 "end": {
// CHECK-NEXT:                  "col": 9, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 83
// CHECK-NEXT:                 }
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "type": {
// CHECK-NEXT:                 "qualType": "NSMutableArray *"
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "valueCategory": "rvalue", 
// CHECK-NEXT:                "castKind": "LValueToRValue", 
// CHECK-NEXT:                "inner": [
// CHECK-NEXT:                 {
// CHECK-NEXT:                  "id": "0x{{.*}}", 
// CHECK-NEXT:                  "kind": "DeclRefExpr", 
// CHECK-NEXT:                  "range": {
// CHECK-NEXT:                   "begin": {
// CHECK-NEXT:                    "col": 9, 
// CHECK-NEXT:                    "file": "{{.*}}", 
// CHECK-NEXT:                    "line": 83
// CHECK-NEXT:                   }, 
// CHECK-NEXT:                   "end": {
// CHECK-NEXT:                    "col": 9, 
// CHECK-NEXT:                    "file": "{{.*}}", 
// CHECK-NEXT:                    "line": 83
// CHECK-NEXT:                   }
// CHECK-NEXT:                  }, 
// CHECK-NEXT:                  "type": {
// CHECK-NEXT:                   "qualType": "NSMutableArray *"
// CHECK-NEXT:                  }, 
// CHECK-NEXT:                  "valueCategory": "lvalue", 
// CHECK-NEXT:                  "referencedDecl": {
// CHECK-NEXT:                   "id": "0x{{.*}}", 
// CHECK-NEXT:                   "kind": "ParmVarDecl", 
// CHECK-NEXT:                   "name": "Array", 
// CHECK-NEXT:                   "type": {
// CHECK-NEXT:                    "qualType": "NSMutableArray *"
// CHECK-NEXT:                   }
// CHECK-NEXT:                  }
// CHECK-NEXT:                 }
// CHECK-NEXT:                ]
// CHECK-NEXT:               }
// CHECK-NEXT:              ]
// CHECK-NEXT:             }, 
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "OpaqueValueExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 15, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 83
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 15, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 83
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "int"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "inner": [
// CHECK-NEXT:               {
// CHECK-NEXT:                "id": "0x{{.*}}", 
// CHECK-NEXT:                "kind": "IntegerLiteral", 
// CHECK-NEXT:                "range": {
// CHECK-NEXT:                 "begin": {
// CHECK-NEXT:                  "col": 15, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 83
// CHECK-NEXT:                 }, 
// CHECK-NEXT:                 "end": {
// CHECK-NEXT:                  "col": 15, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 83
// CHECK-NEXT:                 }
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "type": {
// CHECK-NEXT:                 "qualType": "int"
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "valueCategory": "rvalue", 
// CHECK-NEXT:                "value": "0"
// CHECK-NEXT:               }
// CHECK-NEXT:              ]
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }, 
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}", 
// CHECK-NEXT:      "kind": "PseudoObjectExpr", 
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 2, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 85
// CHECK-NEXT:       }, 
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 24, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 85
// CHECK-NEXT:       }
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "desugaredQualType": "id", 
// CHECK-NEXT:       "qualType": "id"
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "valueCategory": "rvalue", 
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "BinaryOperator", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 2, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 85
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 24, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 85
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "void *"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "opcode": "=", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "ObjCSubscriptRefExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 2, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 85
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 13, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 85
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "<pseudo-object type>"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "lvalue", 
// CHECK-NEXT:          "subscriptKind": "dictionary", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "OpaqueValueExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 2, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 85
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 2, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 85
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "NSMutableDictionary *"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "ImplicitCastExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 2, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 85
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 2, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 85
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "NSMutableDictionary *"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "castKind": "LValueToRValue", 
// CHECK-NEXT:              "inner": [
// CHECK-NEXT:               {
// CHECK-NEXT:                "id": "0x{{.*}}", 
// CHECK-NEXT:                "kind": "DeclRefExpr", 
// CHECK-NEXT:                "range": {
// CHECK-NEXT:                 "begin": {
// CHECK-NEXT:                  "col": 2, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 85
// CHECK-NEXT:                 }, 
// CHECK-NEXT:                 "end": {
// CHECK-NEXT:                  "col": 2, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 85
// CHECK-NEXT:                 }
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "type": {
// CHECK-NEXT:                 "qualType": "NSMutableDictionary *"
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "valueCategory": "lvalue", 
// CHECK-NEXT:                "referencedDecl": {
// CHECK-NEXT:                 "id": "0x{{.*}}", 
// CHECK-NEXT:                 "kind": "ParmVarDecl", 
// CHECK-NEXT:                 "name": "Dict", 
// CHECK-NEXT:                 "type": {
// CHECK-NEXT:                  "qualType": "NSMutableDictionary *"
// CHECK-NEXT:                 }
// CHECK-NEXT:                }
// CHECK-NEXT:               }
// CHECK-NEXT:              ]
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }, 
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "OpaqueValueExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 7, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 85
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 8, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 85
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "NSString *"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "ObjCStringLiteral", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 7, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 85
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 8, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 85
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "NSString *"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "inner": [
// CHECK-NEXT:               {
// CHECK-NEXT:                "id": "0x{{.*}}", 
// CHECK-NEXT:                "kind": "StringLiteral", 
// CHECK-NEXT:                "range": {
// CHECK-NEXT:                 "begin": {
// CHECK-NEXT:                  "col": 8, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 85
// CHECK-NEXT:                 }, 
// CHECK-NEXT:                 "end": {
// CHECK-NEXT:                  "col": 8, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 85
// CHECK-NEXT:                 }
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "type": {
// CHECK-NEXT:                 "qualType": "char [4]"
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "valueCategory": "lvalue", 
// CHECK-NEXT:                "value": "\"key\""
// CHECK-NEXT:               }
// CHECK-NEXT:              ]
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }, 
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "OpaqueValueExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 17, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 85
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 24, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 85
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "void *"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "CStyleCastExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 17, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 85
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 24, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 85
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "void *"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "castKind": "NullToPointer", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "IntegerLiteral", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 24, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 85
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 24, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 85
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "int"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "value": "0"
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }, 
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "OpaqueValueExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 2, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 85
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 2, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 85
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "NSMutableDictionary *"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "ImplicitCastExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 2, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 85
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 2, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 85
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "NSMutableDictionary *"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "castKind": "LValueToRValue", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "DeclRefExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 2, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 85
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 2, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 85
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "NSMutableDictionary *"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "lvalue", 
// CHECK-NEXT:            "referencedDecl": {
// CHECK-NEXT:             "id": "0x{{.*}}", 
// CHECK-NEXT:             "kind": "ParmVarDecl", 
// CHECK-NEXT:             "name": "Dict", 
// CHECK-NEXT:             "type": {
// CHECK-NEXT:              "qualType": "NSMutableDictionary *"
// CHECK-NEXT:             }
// CHECK-NEXT:            }
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }, 
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "OpaqueValueExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 7, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 85
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 8, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 85
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "NSString *"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "ObjCStringLiteral", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 7, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 85
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 8, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 85
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "NSString *"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "StringLiteral", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 8, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 85
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 8, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 85
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "char [4]"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "lvalue", 
// CHECK-NEXT:            "value": "\"key\""
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }, 
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "OpaqueValueExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 17, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 85
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 24, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 85
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "void *"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "CStyleCastExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 17, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 85
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 24, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 85
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "void *"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "castKind": "NullToPointer", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "IntegerLiteral", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 24, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 85
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 24, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 85
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "int"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "value": "0"
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }, 
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "OpaqueValueExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 17, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 85
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 24, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 85
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "desugaredQualType": "id", 
// CHECK-NEXT:         "qualType": "id"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "ImplicitCastExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 17, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 85
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 24, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 85
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "desugaredQualType": "id", 
// CHECK-NEXT:           "qualType": "id"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "castKind": "NullToPointer", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "OpaqueValueExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 17, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 85
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 24, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 85
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "void *"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "CStyleCastExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 17, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 85
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 24, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 85
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "void *"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "castKind": "NullToPointer", 
// CHECK-NEXT:              "inner": [
// CHECK-NEXT:               {
// CHECK-NEXT:                "id": "0x{{.*}}", 
// CHECK-NEXT:                "kind": "IntegerLiteral", 
// CHECK-NEXT:                "range": {
// CHECK-NEXT:                 "begin": {
// CHECK-NEXT:                  "col": 24, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 85
// CHECK-NEXT:                 }, 
// CHECK-NEXT:                 "end": {
// CHECK-NEXT:                  "col": 24, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 85
// CHECK-NEXT:                 }
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "type": {
// CHECK-NEXT:                 "qualType": "int"
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "valueCategory": "rvalue", 
// CHECK-NEXT:                "value": "0"
// CHECK-NEXT:               }
// CHECK-NEXT:              ]
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }, 
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "ObjCMessageExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 2, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 85
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 2, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 85
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "void"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "selector": "setObject:forKeyedSubscript:", 
// CHECK-NEXT:        "receiverKind": "instance", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "OpaqueValueExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 2, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 85
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 2, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 85
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "NSMutableDictionary *"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "ImplicitCastExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 2, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 85
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 2, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 85
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "NSMutableDictionary *"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "castKind": "LValueToRValue", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "DeclRefExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 2, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 85
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 2, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 85
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "NSMutableDictionary *"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "lvalue", 
// CHECK-NEXT:              "referencedDecl": {
// CHECK-NEXT:               "id": "0x{{.*}}", 
// CHECK-NEXT:               "kind": "ParmVarDecl", 
// CHECK-NEXT:               "name": "Dict", 
// CHECK-NEXT:               "type": {
// CHECK-NEXT:                "qualType": "NSMutableDictionary *"
// CHECK-NEXT:               }
// CHECK-NEXT:              }
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }, 
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "OpaqueValueExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 17, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 85
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 24, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 85
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "desugaredQualType": "id", 
// CHECK-NEXT:           "qualType": "id"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "ImplicitCastExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 17, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 85
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 24, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 85
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "desugaredQualType": "id", 
// CHECK-NEXT:             "qualType": "id"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "castKind": "NullToPointer", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "OpaqueValueExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 17, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 85
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 24, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 85
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "void *"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "inner": [
// CHECK-NEXT:               {
// CHECK-NEXT:                "id": "0x{{.*}}", 
// CHECK-NEXT:                "kind": "CStyleCastExpr", 
// CHECK-NEXT:                "range": {
// CHECK-NEXT:                 "begin": {
// CHECK-NEXT:                  "col": 17, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 85
// CHECK-NEXT:                 }, 
// CHECK-NEXT:                 "end": {
// CHECK-NEXT:                  "col": 24, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 85
// CHECK-NEXT:                 }
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "type": {
// CHECK-NEXT:                 "qualType": "void *"
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "valueCategory": "rvalue", 
// CHECK-NEXT:                "castKind": "NullToPointer", 
// CHECK-NEXT:                "inner": [
// CHECK-NEXT:                 {
// CHECK-NEXT:                  "id": "0x{{.*}}", 
// CHECK-NEXT:                  "kind": "IntegerLiteral", 
// CHECK-NEXT:                  "range": {
// CHECK-NEXT:                   "begin": {
// CHECK-NEXT:                    "col": 24, 
// CHECK-NEXT:                    "file": "{{.*}}", 
// CHECK-NEXT:                    "line": 85
// CHECK-NEXT:                   }, 
// CHECK-NEXT:                   "end": {
// CHECK-NEXT:                    "col": 24, 
// CHECK-NEXT:                    "file": "{{.*}}", 
// CHECK-NEXT:                    "line": 85
// CHECK-NEXT:                   }
// CHECK-NEXT:                  }, 
// CHECK-NEXT:                  "type": {
// CHECK-NEXT:                   "qualType": "int"
// CHECK-NEXT:                  }, 
// CHECK-NEXT:                  "valueCategory": "rvalue", 
// CHECK-NEXT:                  "value": "0"
// CHECK-NEXT:                 }
// CHECK-NEXT:                ]
// CHECK-NEXT:               }
// CHECK-NEXT:              ]
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }, 
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "ImplicitCastExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 7, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 85
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 8, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 85
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "desugaredQualType": "id", 
// CHECK-NEXT:           "qualType": "id"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "castKind": "BitCast", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "OpaqueValueExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 7, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 85
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 8, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 85
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "NSString *"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "ObjCStringLiteral", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 7, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 85
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 8, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 85
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "NSString *"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "inner": [
// CHECK-NEXT:               {
// CHECK-NEXT:                "id": "0x{{.*}}", 
// CHECK-NEXT:                "kind": "StringLiteral", 
// CHECK-NEXT:                "range": {
// CHECK-NEXT:                 "begin": {
// CHECK-NEXT:                  "col": 8, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 85
// CHECK-NEXT:                 }, 
// CHECK-NEXT:                 "end": {
// CHECK-NEXT:                  "col": 8, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 85
// CHECK-NEXT:                 }
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "type": {
// CHECK-NEXT:                 "qualType": "char [4]"
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "valueCategory": "lvalue", 
// CHECK-NEXT:                "value": "\"key\""
// CHECK-NEXT:               }
// CHECK-NEXT:              ]
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }, 
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}", 
// CHECK-NEXT:      "kind": "BinaryOperator", 
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 2, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 86
// CHECK-NEXT:       }, 
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 17, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 86
// CHECK-NEXT:       }
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "desugaredQualType": "id", 
// CHECK-NEXT:       "qualType": "id"
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "valueCategory": "rvalue", 
// CHECK-NEXT:      "opcode": "=", 
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "DeclRefExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 2, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 86
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 2, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 86
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "desugaredQualType": "id", 
// CHECK-NEXT:         "qualType": "id"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "lvalue", 
// CHECK-NEXT:        "referencedDecl": {
// CHECK-NEXT:         "id": "0x{{.*}}", 
// CHECK-NEXT:         "kind": "VarDecl", 
// CHECK-NEXT:         "name": "i", 
// CHECK-NEXT:         "type": {
// CHECK-NEXT:          "desugaredQualType": "id", 
// CHECK-NEXT:          "qualType": "id"
// CHECK-NEXT:         }
// CHECK-NEXT:        }
// CHECK-NEXT:       }, 
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "PseudoObjectExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 6, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 86
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 17, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 86
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "desugaredQualType": "id", 
// CHECK-NEXT:         "qualType": "id"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "ObjCSubscriptRefExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 6, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 86
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 17, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 86
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "<pseudo-object type>"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "lvalue", 
// CHECK-NEXT:          "subscriptKind": "dictionary", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "OpaqueValueExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 6, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 86
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 6, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 86
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "NSMutableDictionary *"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "ImplicitCastExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 6, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 86
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 6, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 86
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "NSMutableDictionary *"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "castKind": "LValueToRValue", 
// CHECK-NEXT:              "inner": [
// CHECK-NEXT:               {
// CHECK-NEXT:                "id": "0x{{.*}}", 
// CHECK-NEXT:                "kind": "DeclRefExpr", 
// CHECK-NEXT:                "range": {
// CHECK-NEXT:                 "begin": {
// CHECK-NEXT:                  "col": 6, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 86
// CHECK-NEXT:                 }, 
// CHECK-NEXT:                 "end": {
// CHECK-NEXT:                  "col": 6, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 86
// CHECK-NEXT:                 }
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "type": {
// CHECK-NEXT:                 "qualType": "NSMutableDictionary *"
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "valueCategory": "lvalue", 
// CHECK-NEXT:                "referencedDecl": {
// CHECK-NEXT:                 "id": "0x{{.*}}", 
// CHECK-NEXT:                 "kind": "ParmVarDecl", 
// CHECK-NEXT:                 "name": "Dict", 
// CHECK-NEXT:                 "type": {
// CHECK-NEXT:                  "qualType": "NSMutableDictionary *"
// CHECK-NEXT:                 }
// CHECK-NEXT:                }
// CHECK-NEXT:               }
// CHECK-NEXT:              ]
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }, 
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "OpaqueValueExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 11, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 86
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 12, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 86
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "NSString *"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "ObjCStringLiteral", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 11, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 86
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 12, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 86
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "NSString *"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "inner": [
// CHECK-NEXT:               {
// CHECK-NEXT:                "id": "0x{{.*}}", 
// CHECK-NEXT:                "kind": "StringLiteral", 
// CHECK-NEXT:                "range": {
// CHECK-NEXT:                 "begin": {
// CHECK-NEXT:                  "col": 12, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 86
// CHECK-NEXT:                 }, 
// CHECK-NEXT:                 "end": {
// CHECK-NEXT:                  "col": 12, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 86
// CHECK-NEXT:                 }
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "type": {
// CHECK-NEXT:                 "qualType": "char [4]"
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "valueCategory": "lvalue", 
// CHECK-NEXT:                "value": "\"key\""
// CHECK-NEXT:               }
// CHECK-NEXT:              ]
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }, 
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "OpaqueValueExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 6, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 86
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 6, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 86
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "NSMutableDictionary *"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "ImplicitCastExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 6, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 86
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 6, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 86
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "NSMutableDictionary *"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "castKind": "LValueToRValue", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "DeclRefExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 6, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 86
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 6, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 86
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "NSMutableDictionary *"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "lvalue", 
// CHECK-NEXT:              "referencedDecl": {
// CHECK-NEXT:               "id": "0x{{.*}}", 
// CHECK-NEXT:               "kind": "ParmVarDecl", 
// CHECK-NEXT:               "name": "Dict", 
// CHECK-NEXT:               "type": {
// CHECK-NEXT:                "qualType": "NSMutableDictionary *"
// CHECK-NEXT:               }
// CHECK-NEXT:              }
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }, 
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "OpaqueValueExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 11, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 86
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 12, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 86
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "NSString *"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "ObjCStringLiteral", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 11, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 86
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 12, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 86
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "NSString *"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "StringLiteral", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 12, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 86
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 12, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 86
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "char [4]"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "lvalue", 
// CHECK-NEXT:              "value": "\"key\""
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }, 
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "ObjCMessageExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 6, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 86
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 6, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 86
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "desugaredQualType": "id", 
// CHECK-NEXT:           "qualType": "id"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "selector": "objectForKeyedSubscript:", 
// CHECK-NEXT:          "receiverKind": "instance", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "OpaqueValueExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 6, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 86
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 6, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 86
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "NSMutableDictionary *"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "ImplicitCastExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 6, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 86
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 6, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 86
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "NSMutableDictionary *"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "castKind": "LValueToRValue", 
// CHECK-NEXT:              "inner": [
// CHECK-NEXT:               {
// CHECK-NEXT:                "id": "0x{{.*}}", 
// CHECK-NEXT:                "kind": "DeclRefExpr", 
// CHECK-NEXT:                "range": {
// CHECK-NEXT:                 "begin": {
// CHECK-NEXT:                  "col": 6, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 86
// CHECK-NEXT:                 }, 
// CHECK-NEXT:                 "end": {
// CHECK-NEXT:                  "col": 6, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 86
// CHECK-NEXT:                 }
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "type": {
// CHECK-NEXT:                 "qualType": "NSMutableDictionary *"
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "valueCategory": "lvalue", 
// CHECK-NEXT:                "referencedDecl": {
// CHECK-NEXT:                 "id": "0x{{.*}}", 
// CHECK-NEXT:                 "kind": "ParmVarDecl", 
// CHECK-NEXT:                 "name": "Dict", 
// CHECK-NEXT:                 "type": {
// CHECK-NEXT:                  "qualType": "NSMutableDictionary *"
// CHECK-NEXT:                 }
// CHECK-NEXT:                }
// CHECK-NEXT:               }
// CHECK-NEXT:              ]
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }, 
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "ImplicitCastExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 11, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 86
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 12, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 86
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "desugaredQualType": "id", 
// CHECK-NEXT:             "qualType": "id"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "rvalue", 
// CHECK-NEXT:            "castKind": "BitCast", 
// CHECK-NEXT:            "inner": [
// CHECK-NEXT:             {
// CHECK-NEXT:              "id": "0x{{.*}}", 
// CHECK-NEXT:              "kind": "OpaqueValueExpr", 
// CHECK-NEXT:              "range": {
// CHECK-NEXT:               "begin": {
// CHECK-NEXT:                "col": 11, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 86
// CHECK-NEXT:               }, 
// CHECK-NEXT:               "end": {
// CHECK-NEXT:                "col": 12, 
// CHECK-NEXT:                "file": "{{.*}}", 
// CHECK-NEXT:                "line": 86
// CHECK-NEXT:               }
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "type": {
// CHECK-NEXT:               "qualType": "NSString *"
// CHECK-NEXT:              }, 
// CHECK-NEXT:              "valueCategory": "rvalue", 
// CHECK-NEXT:              "inner": [
// CHECK-NEXT:               {
// CHECK-NEXT:                "id": "0x{{.*}}", 
// CHECK-NEXT:                "kind": "ObjCStringLiteral", 
// CHECK-NEXT:                "range": {
// CHECK-NEXT:                 "begin": {
// CHECK-NEXT:                  "col": 11, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 86
// CHECK-NEXT:                 }, 
// CHECK-NEXT:                 "end": {
// CHECK-NEXT:                  "col": 12, 
// CHECK-NEXT:                  "file": "{{.*}}", 
// CHECK-NEXT:                  "line": 86
// CHECK-NEXT:                 }
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "type": {
// CHECK-NEXT:                 "qualType": "NSString *"
// CHECK-NEXT:                }, 
// CHECK-NEXT:                "valueCategory": "rvalue", 
// CHECK-NEXT:                "inner": [
// CHECK-NEXT:                 {
// CHECK-NEXT:                  "id": "0x{{.*}}", 
// CHECK-NEXT:                  "kind": "StringLiteral", 
// CHECK-NEXT:                  "range": {
// CHECK-NEXT:                   "begin": {
// CHECK-NEXT:                    "col": 12, 
// CHECK-NEXT:                    "file": "{{.*}}", 
// CHECK-NEXT:                    "line": 86
// CHECK-NEXT:                   }, 
// CHECK-NEXT:                   "end": {
// CHECK-NEXT:                    "col": 12, 
// CHECK-NEXT:                    "file": "{{.*}}", 
// CHECK-NEXT:                    "line": 86
// CHECK-NEXT:                   }
// CHECK-NEXT:                  }, 
// CHECK-NEXT:                  "type": {
// CHECK-NEXT:                   "qualType": "char [4]"
// CHECK-NEXT:                  }, 
// CHECK-NEXT:                  "valueCategory": "lvalue", 
// CHECK-NEXT:                  "value": "\"key\""
// CHECK-NEXT:                 }
// CHECK-NEXT:                ]
// CHECK-NEXT:               }
// CHECK-NEXT:              ]
// CHECK-NEXT:             }
// CHECK-NEXT:            ]
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   }
// CHECK-NEXT:  ]
// CHECK-NEXT: }


// CHECK:  "kind": "FunctionDecl", 
// CHECK-NEXT:  "loc": {
// CHECK-NEXT:   "col": 6, 
// CHECK-NEXT:   "file": "{{.*}}", 
// CHECK-NEXT:   "line": 89
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "range": {
// CHECK-NEXT:   "begin": {
// CHECK-NEXT:    "col": 1, 
// CHECK-NEXT:    "file": "{{.*}}", 
// CHECK-NEXT:    "line": 89
// CHECK-NEXT:   }, 
// CHECK-NEXT:   "end": {
// CHECK-NEXT:    "col": 1, 
// CHECK-NEXT:    "file": "{{.*}}", 
// CHECK-NEXT:    "line": 91
// CHECK-NEXT:   }
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "name": "TestObjCIVarRef", 
// CHECK-NEXT:  "type": {
// CHECK-NEXT:   "qualType": "void (I *)"
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "inner": [
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}", 
// CHECK-NEXT:    "kind": "ParmVarDecl", 
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 25, 
// CHECK-NEXT:     "file": "{{.*}}", 
// CHECK-NEXT:     "line": 89
// CHECK-NEXT:    }, 
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 22, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 89
// CHECK-NEXT:     }, 
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 25, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 89
// CHECK-NEXT:     }
// CHECK-NEXT:    }, 
// CHECK-NEXT:    "isUsed": true, 
// CHECK-NEXT:    "name": "Ptr", 
// CHECK-NEXT:    "type": {
// CHECK-NEXT:     "qualType": "I *"
// CHECK-NEXT:    }
// CHECK-NEXT:   }, 
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}", 
// CHECK-NEXT:    "kind": "CompoundStmt", 
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 30, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 89
// CHECK-NEXT:     }, 
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 1, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 91
// CHECK-NEXT:     }
// CHECK-NEXT:    }, 
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}", 
// CHECK-NEXT:      "kind": "BinaryOperator", 
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 3, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 90
// CHECK-NEXT:       }, 
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 17, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 90
// CHECK-NEXT:       }
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "int"
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "valueCategory": "rvalue", 
// CHECK-NEXT:      "opcode": "=", 
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "ObjCIvarRefExpr", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 3, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 90
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 8, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 90
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "int"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "lvalue", 
// CHECK-NEXT:        "decl": {
// CHECK-NEXT:         "id": "0x{{.*}}", 
// CHECK-NEXT:         "kind": "ObjCIvarDecl", 
// CHECK-NEXT:         "name": "public", 
// CHECK-NEXT:         "type": {
// CHECK-NEXT:          "qualType": "int"
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "isArrow": true, 
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}", 
// CHECK-NEXT:          "kind": "ImplicitCastExpr", 
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 3, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 90
// CHECK-NEXT:           }, 
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 3, 
// CHECK-NEXT:            "file": "{{.*}}", 
// CHECK-NEXT:            "line": 90
// CHECK-NEXT:           }
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "I *"
// CHECK-NEXT:          }, 
// CHECK-NEXT:          "valueCategory": "rvalue", 
// CHECK-NEXT:          "castKind": "LValueToRValue", 
// CHECK-NEXT:          "inner": [
// CHECK-NEXT:           {
// CHECK-NEXT:            "id": "0x{{.*}}", 
// CHECK-NEXT:            "kind": "DeclRefExpr", 
// CHECK-NEXT:            "range": {
// CHECK-NEXT:             "begin": {
// CHECK-NEXT:              "col": 3, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 90
// CHECK-NEXT:             }, 
// CHECK-NEXT:             "end": {
// CHECK-NEXT:              "col": 3, 
// CHECK-NEXT:              "file": "{{.*}}", 
// CHECK-NEXT:              "line": 90
// CHECK-NEXT:             }
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "type": {
// CHECK-NEXT:             "qualType": "I *"
// CHECK-NEXT:            }, 
// CHECK-NEXT:            "valueCategory": "lvalue", 
// CHECK-NEXT:            "referencedDecl": {
// CHECK-NEXT:             "id": "0x{{.*}}", 
// CHECK-NEXT:             "kind": "ParmVarDecl", 
// CHECK-NEXT:             "name": "Ptr", 
// CHECK-NEXT:             "type": {
// CHECK-NEXT:              "qualType": "I *"
// CHECK-NEXT:             }
// CHECK-NEXT:            }
// CHECK-NEXT:           }
// CHECK-NEXT:          ]
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }, 
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}", 
// CHECK-NEXT:        "kind": "IntegerLiteral", 
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 17, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 90
// CHECK-NEXT:         }, 
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 17, 
// CHECK-NEXT:          "file": "{{.*}}", 
// CHECK-NEXT:          "line": 90
// CHECK-NEXT:         }
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "int"
// CHECK-NEXT:        }, 
// CHECK-NEXT:        "valueCategory": "rvalue", 
// CHECK-NEXT:        "value": "0"
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   }
// CHECK-NEXT:  ]
// CHECK-NEXT: }


// CHECK:  "kind": "FunctionDecl", 
// CHECK-NEXT:  "loc": {
// CHECK-NEXT:   "col": 6, 
// CHECK-NEXT:   "file": "{{.*}}", 
// CHECK-NEXT:   "line": 93
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "range": {
// CHECK-NEXT:   "begin": {
// CHECK-NEXT:    "col": 1, 
// CHECK-NEXT:    "file": "{{.*}}", 
// CHECK-NEXT:    "line": 93
// CHECK-NEXT:   }, 
// CHECK-NEXT:   "end": {
// CHECK-NEXT:    "col": 1, 
// CHECK-NEXT:    "file": "{{.*}}", 
// CHECK-NEXT:    "line": 96
// CHECK-NEXT:   }
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "name": "TestObjCBoolLiteral", 
// CHECK-NEXT:  "type": {
// CHECK-NEXT:   "qualType": "void ()"
// CHECK-NEXT:  }, 
// CHECK-NEXT:  "inner": [
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}", 
// CHECK-NEXT:    "kind": "CompoundStmt", 
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 28, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 93
// CHECK-NEXT:     }, 
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 1, 
// CHECK-NEXT:      "file": "{{.*}}", 
// CHECK-NEXT:      "line": 96
// CHECK-NEXT:     }
// CHECK-NEXT:    }, 
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}", 
// CHECK-NEXT:      "kind": "ObjCBoolLiteralExpr", 
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 3, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 94
// CHECK-NEXT:       }, 
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 3, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 94
// CHECK-NEXT:       }
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "desugaredQualType": "signed char", 
// CHECK-NEXT:       "qualType": "BOOL"
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "valueCategory": "rvalue", 
// CHECK-NEXT:      "value": "__objc_yes"
// CHECK-NEXT:     }, 
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}", 
// CHECK-NEXT:      "kind": "ObjCBoolLiteralExpr", 
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 3, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 95
// CHECK-NEXT:       }, 
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 3, 
// CHECK-NEXT:        "file": "{{.*}}", 
// CHECK-NEXT:        "line": 95
// CHECK-NEXT:       }
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "desugaredQualType": "signed char", 
// CHECK-NEXT:       "qualType": "BOOL"
// CHECK-NEXT:      }, 
// CHECK-NEXT:      "valueCategory": "rvalue", 
// CHECK-NEXT:      "value": "__objc_no"
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   }
// CHECK-NEXT:  ]
// CHECK-NEXT: }
