import type.magic;
import type.leb128;

namespace auto util {
    fn warn(str fmt, auto ... args) {
        str message = builtin::std::format(fmt, args);
        str error = std::format("$[{:#04x}] WARN: {}", $, message);
        return std::print(error);
    };

    fn error(str fmt, auto ... args) {
        str message = builtin::std::format(fmt, args);
        str error = std::format("$[{:#04x}] ERROR: {}", $, message);
        return std::error(error);
    };

    fn debug(str fmt, auto ... args) {
        str message = builtin::std::format(fmt, args);
        str debug = std::format("$[{:#04x}] DEBUG: {}", $, message);
        return std::print(debug);
    };
    
    fn assert(bool condition, str fmt, auto ... args) {
        if (!condition) {
            str message = builtin::std::format(fmt, args);
            str error = std::format("$[{:#04x}] ERROR(assert): {}", $, message);
            return std::error(error);
        }
    };

    struct Lit<Type, auto ExpectedValue> {
        Type value;
        util::assert(value == ExpectedValue, "Expected \"{}\", got \"{}\"", ExpectedValue, value);
    } [[sealed, format("util::impl::transform_value")]];

    namespace impl {
        fn transform_value(ref auto object) {
          return object.value;
        };
        
        fn transform_values(ref auto object) {
          return object.values;
        };
    }
}

// Values

using U32 = type::uLEB128;
using I32 = type::LEB128;
using I64 = type::LEB128;
using S33 = type::LEB128;

using F32 = float;
using F64 = double;

struct Vector<T> {
  U32 size;
  T values[size];
} [[transform("util::impl::transform_values")]];

struct Name {
    Vector<char> value;
} [[sealed, transform("util::impl::transform_value")]];

// Indices

using TypeIdx = U32;
using FuncIdx = U32;
using TableIdx = U32;
using MemIdx = U32;
using GlobalIdx = U32;
using ElemIdx = U32;
using DataIdx = U32;
using LocalIdx = U32;
using LabelIdx = U32;

// Types

enum NumberType : u8 {
    i32 = 0x7F,
    i64 = 0x7E,
    f32 = 0x7D,
    f64 = 0x7C
};

enum VectorType : u8 {
    v128 = 0x7B
};

enum ReferenceType : u8 {
    funcref = 0x70,
    externref = 0x6F
};


enum ValueType : u8 {
	i32 = 0x7F,
	i64 = 0x7E,
	f32 = 0x7D,
	f64 = 0x7C,
	v128 = 0x7B,
	funcref = 0x70,
	externref = 0x6F,
};

struct ResultType {
  Vector<ValueType>;
};

struct FunctionType {
  util::Lit<u8, 0x60>;
  ResultType;
  ResultType;
};

struct Limit {
	bool hasMax;
	U32 min;
	if (hasMax)
		U32 max;
};

struct MemoryType {
  Limit;
};

struct TableType {
  ReferenceType;
  Limit;
};

enum Mutability : u8 {
  Const,
  Var
};

struct GlobalType {
  ValueType;
  Mutability;
};

// Instructions

enum OpCode : u8 {
  Unreachable = 0x00,
  Nop,
  Block,
  Loop,
  If,
  Else,

  //

  End = 0x0B,
  Br,
  BrIf,
  BrTable,
  Return,
  Call,
  CallIndirect,

  //

  Drop = 0x1A,
  Select,

  //

  LocalGet = 0x20,
  LocalSet,
  LocalTee,
  GlobalGet,
  GlobalSet,

  //

  I32Load = 0x28,
  I64Load,
  F32Load,
  F64Load,
  I32Load8S,
  I32Load8U,
  I32Load16S,
  I32Load16U,
  I64Load8S,
  I64Load8U,
  I64Load16S,
  I64Load16U,
  I64Load32S,
  I64Load32U,
  I32Store,
  I64Store,
  F32Store,
  F64Store,
  I32Store8,
  I32Store16,
  I64Store8,
  I64Store16,
  I64Store32,
  MemorySize,
  MemoryGrow,
  I32Const,
  I64Const,
  F32Const,
  F64Const,
  I32Eqz,
  I32Eq,
  I32Ne,
  I32LtS,
  I32LtU,
  I32GtS,
  I32GtU,
  I32LeS,
  I32LeU,
  I32GeS,
  I32GeU,
  I64Eqz,
  I64Eq,
  I64Ne,
  I64LtS,
  I64LtU,
  I64GtS,
  I64GtU,
  I64LeS,
  I64LeU,
  I64GeS,
  I64GeU,
  F32Eq,
  F32Ne,
  F32Lt,
  F32Gt,
  F32Le,
  F32Ge,
  F64Eq,
  F64Ne,
  F64Lt,
  F64Gt,
  F64Le,
  F64Ge,
  I32Clz,
  I32Ctz,
  I32Popcnt,
  I32Add,
  I32Sub,
  I32Mul,
  I32DivS,
  I32DivU,
  I32RemS,
  I32RemU,
  I32And,
  I32Or,
  I32Xor,
  I32Shl,
  I32ShrS,
  I32ShrU,
  I32Rotl,
  I32Rotr,
  I64Clz,
  I64Ctz,
  I64Popcnt,
  I64Add,
  I64Sub,
  I64Mul,
  I64DivS,
  I64DivU,
  I64RemS,
  I64RemU,
  I64And,
  I64Or,
  I64Xor,
  I64Shl,
  I64ShrS,
  I64ShrU,
  I64Rotl,
  I64Rotr,
  F32Abs,
  F32Neg,
  F32Ceil,
  F32Floor,
  F32Trunc,
  F32Nearest,
  F32Sqrt,
  F32Add,
  F32Sub,
  F32Mul,
  F32Div,
  F32Min,
  F32Max,
  F32Copysign,
  F64Abs,
  F64Neg,
  F64Ceil,
  F64Floor,
  F64Trunc,
  F64Nearest,
  F64Sqrt,
  F64Add,
  F64Sub,
  F64Mul,
  F64Div,
  F64Min,
  F64Max,
  F64Copysign,
  I32WrapI64,
  I32TruncF32S,
  I32TruncF32U,
  I32TruncF64S,
  I32TruncF64U,
  I64ExtendI32S,
  I64ExtendI32U,
  F64TruncF32S,
  F64TruncF32U,
  F64TruncF64S,
  F64TruncF64U,
  F32ConvertI32S,
  F32ConvertI32U,
  F32ConvertF64S,
  F32ConvertF64U,
  F32DemoteF64,
  F64ConvertI32S,
  F64ConvertI32U,
  F64ConvertI64S,
  F64ConvertI64U,
  F64PromoteF32,
  I32ReinterpretF32,
  I64ReinterpretF64,
  F32ReinterpretI32,
  F64ReinterpretI64,
};

enum BlockTypeKind : u8 {
  Empty,
  ValueType,
  TypeIndex
};

struct BlockType {
  u8 tag;
  match(tag) {
    (0x40): {
      BlockTypeKind kind = BlockTypeKind::Empty;
    }
    (0x7F | 0x7E | 0x7D | 0x7C | 0x7B | 0x70 | 0x6F): {
      BlockTypeKind kind = BlockTypeKind::ValueType; 
      ValueType value = tag;
    }
    (_): {
      BlockTypeKind kind = BlockTypeKind::TypeIndex;
      S33 value;
    }
  }
};

struct MemoryArg {
  U32;
  U32;
};

struct Instruction {
  OpCode opcode;

  match(opcode) {
    (OpCode::Block | OpCode::Loop): {
      BlockType;
      Instruction instructions[while(std::mem::read_unsigned($, 1) != 0x0B)];
      util::Lit<u8, 0x0B>;
    }
    (OpCode::If): {
      BlockType;
      Instruction instructions[while(std::mem::read_unsigned($, 1) != 0x0B && std::mem::read_unsigned($, 1) != 0x05)];
      u8 _marker [[hidden]];
      if(_marker == 0x05) {
        Instruction instructions2[while(std::mem::read_unsigned($, 1) != 0x0B)];
        util::Lit<u8, 0x0B>;
      }
    }
    (OpCode::Br | OpCode::BrIf): {
      LabelIdx;
    }
    (OpCode::BrTable): {
      Vector<LabelIdx> labels;
      LabelIdx;
    }
    (OpCode::Call): {
      FuncIdx;
    }
    (OpCode::CallIndirect): {
      TypeIdx;
      TableIdx;
    }
    (OpCode::LocalGet | OpCode::LocalSet | OpCode::LocalTee): {
      LocalIdx;
    }
    (OpCode::GlobalGet | OpCode::GlobalSet): {
      GlobalIdx;
    }
    // i32.load to i64.store32
    (0x28 ... 0x3E): {
      MemoryArg;
    }
    (OpCode::MemorySize | OpCode::MemoryGrow): {
      u8;
    }
    (OpCode::I32Const): {
      I32;
    }
    (OpCode::I64Const): {
      I64;
    }
    (OpCode::F32Const): {
      F32;
    }
    (OpCode::F64Const): {
      F64;
    }
  }
};

struct Expression {
  Instruction instructions2[while(std::mem::read_unsigned($, 1) != 0x0B)];
  util::Lit<u8, 0x0B>;
};

// Modules

enum SectionKind : u8 {
  Custom,
  Type,
  Import,
  Function,
  Table,
  Memory,
  Global,
  Export,
  Start,
  Element,
  Code,
  Data,
  DataCount
};

struct TypeSection {
  Vector<FunctionType>;
};

struct ImportDescription {
  u8 tag;
  match(tag) {
    (0x00): TypeIdx;
    (0x01): TableIdx;
    (0x02): MemoryType;
    (0x03): GlobalType;
  }
};

struct Import {
  Name;
  Name;
  ImportDescription;
};

struct ImportSection {
  Vector<Import>;
};

struct FunctionSection {
  Vector<TypeIdx>;
};

struct Table {
  TableType;
};

struct TableSection {
  Vector<Table>;
};

struct Memory {
  MemoryType;
};

struct MemorySection {
  Vector<Memory>;
};

struct Global {
  GlobalType;
  Expression;
};

struct GlobalSection {
  Vector<Global>;
};

struct ExportDescription {
  u8 tag;
  match(tag) {
    (0x00): FuncIdx;
    (0x01): TableIdx;
    (0x02): MemIdx;
    (0x03): GlobalIdx;
  }
};

struct Export {
  Name;
  ExportDescription;
};

struct ExportSection {
  Vector<Export>;
};

struct Start {
  FuncIdx;
};

struct StartSection {
  Start;
};

enum ElementKind : u8 {
  funcref
};

struct Element {
  U32 tag;
  match(tag) {
    (0): {
      Expression;
      Vector<FuncIdx>;
    }
    (1): {
      ElementKind;
      Vector<FuncIdx>;
    }
    (2): {
      TableIdx;
      Expression;
      ElementKind;
      Vector<FuncIdx>;
    }
    (3): {
      ElementKind;
      Vector<FuncIdx>;
    }
    (4): {
      Expression;
      Vector<Expression>;
    }
    (5): {
      ReferenceType;
      Vector<Expression>;
    }
    (6): {
      TableIdx;
      Expression;
      ReferenceType;
      Vector<Expression>;
    }
    (7): {
      ReferenceType;
      Vector<Expression>;
    }
  }
};

struct ElementSection {
  Vector<Element>;
};

struct Locals {
  U32;
  ValueType;
};

struct Function {
  Vector<Locals>;
  Expression;
};

struct Code {
  U32 size;
  Function;
};

struct CodeSection {
  Vector<Code>;
};

struct Data {
  U32 tag;
  match(tag) {
    (0): {
      Expression;
      Vector<u8>;
    }
    (1): {
      Vector<u8>;
    }
    (2): {
      MemIdx;
      Expression;
      Vector<u8>;
    }
  }
};

struct DataSection {
  Vector<Data>;
};

struct DataCountSection {
  U32;
};

struct Section {
  SectionKind kind;
  U32 size;
  match(kind) {
    (SectionKind::Custom): u8 data[size] [[sealed]];
    (SectionKind::Type): TypeSection [[inline]];
    (SectionKind::Import): ImportSection [[inline]];
    (SectionKind::Function): FunctionSection [[inline]];
    (SectionKind::Table): TableSection [[inline]];
    (SectionKind::Memory): MemorySection [[inline]];
    (SectionKind::Global): GlobalSection [[inline]];
    (SectionKind::Export): ExportSection [[inline]];
    (SectionKind::Start): StartSection [[inline]];
    (SectionKind::Element): ElementSection [[inline]];
    (SectionKind::Code): CodeSection [[inline]];
    (SectionKind::Data): DataSection [[inline]];
    (SectionKind::DataCount): DataCountSection [[inline]];
  }
};

struct Module {
  type::Magic<"\0asm">;
  u32 version;
  Section section[while(!std::mem::eof())];
};

Module module @ 0x00;