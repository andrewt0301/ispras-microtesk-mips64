/*
 * MicroTESK Komdiv64 Edition
 *
 * Copyright (c) 2016 Institute for System Programming of the Russian Academy of Sciences
 * All Rights Reserved
 *
 * Institute for System Programming of the Russian Academy of Sciences (ISP RAS)
 * 25 Alexander Solzhenitsyn st., Moscow, 109004, Russia
 * http://www.ispras.ru
 * 
 * This file is a part of MicroTESK Komdiv64 Edition (identified hereinafter the "PRODUCT").
 *
 * THE PRODUCT IS PROTECTED BY NATIONAL COPYRIGHT LAWS, THE WIPO COPYRIGHT TREATY (1996), AND BY THE
 * PROVISIONS OF THE BERNE CONVENTION (1971) REFERRED TO IN ALL SUCH TREATIES, AS WELL AS OTHER
 * INTERNATIONAL COPYRIGHT AND INTELLECTUAL PROPERTY LAWS AND TREATIES. ANY UNAUTHORIZED USAGE OF
 * THE PRODUCT IN A COMMERCIAL CONTEXT IS STRICTLY PROHIBITED. IF YOU ARE NOT AUTHORIZED TO USE THE
 * PRODUCT, YOU SHOULD PROMPTLY TERMINATE ITS USAGE AND DELETE ALL THE FILES REFERRED TO IT FROM
 * YOUR COMPUTER. THE PRODUCT SOURCE CODE IS CONFIDENTIAL AND CANNOT BE PUBLISHED IN ANY FORMAT OR
 * MEDIA WITHOUT PRIOR WRITTEN CONSENT OF ISP RAS.
 *
 * THE PRODUCT IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
 * NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, COMPATIBILITY
 * WITH THIRD-PARTY SOFTWARE APPLICATIONS AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE PRODUCT OR THE USE OR
 * OTHER DEALINGS IN THE PRODUCT.
 */

package ru.ispras.microtesk.mips.test.branch;

import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import ru.ispras.fortress.data.DataType;
import ru.ispras.fortress.data.types.bitvector.BitVector;
import ru.ispras.fortress.expression.Node;
import ru.ispras.fortress.expression.NodeValue;
import ru.ispras.fortress.expression.NodeVariable;
import ru.ispras.fortress.randomizer.Randomizer;
import ru.ispras.fortress.util.InvariantChecks;
import ru.ispras.fortress.util.Pair;
import ru.ispras.microtesk.test.testbase.BranchDataGenerator;
import ru.ispras.testbase.TestBaseContext;
import ru.ispras.testbase.TestBaseQuery;
import ru.ispras.testbase.TestData;
import ru.ispras.testbase.TestDataProvider;
import ru.ispras.testbase.generator.Utils;

/**
 * {@link MipsBranchDataGenerator} is a base class for the MIPS branch instructions' generators.
 */
public abstract class MipsBranchDataGenerator extends BranchDataGenerator {
  protected static long positiveValue() {
    return Randomizer.get().nextLongRange(1, Long.MAX_VALUE);
  }

  protected static long nonPositiveValue() {
    return Randomizer.get().nextLongRange(Long.MIN_VALUE, 0);
  }

  protected static long nonNegativeValue() {
    return Randomizer.get().nextLongRange(0, Long.MAX_VALUE);
  }

  protected static Long generateEqual(Long rs, Long rt) {
    if (rs == null) {
      rs = rt;
    } else if (rt == null) {
      rt = rs;
    } else {
      InvariantChecks.checkTrue(rs.equals(rt), "Incorrect values defined");
    }
    if (rs == null) {
      return Randomizer.get().nextLong();
    }
    return rs;
  }

  protected static Pair<Long, Long> generateDistinct(Long rs, Long rt) {
    if (rs == null && rt == null) {
      rs = Randomizer.get().nextLong();
      rt = distinctValue(rs);
    } else if (rs == null) {
      rs = distinctValue(rt);
    } else if (rt == null) {
      rt = distinctValue(rs);
    } else {
      InvariantChecks.checkFalse(rs.equals(rt), "Incorrect values defined");
    }

    return new Pair<>(rs, rt);
  }

  private static long distinctValue(final long x) {
    long value = x;
    do {
      value = Randomizer.get().nextLong();
    } while (value == x);
    return value;
  }

  protected static Long getValue(final String name, final TestBaseQuery query) {
    final String op = getInstructionName(query);
    final Node node = query.getBindings().get(op + "." + name);
    InvariantChecks.checkNotNull(node);
    InvariantChecks.checkTrue(node.getKind() == Node.Kind.VARIABLE);

    final NodeVariable var = (NodeVariable) node;
    if (var.getData().hasValue()) {
      return var.getData().getValue(BitVector.class).longValue();
    }
    return null;
  }

  protected static TestDataProvider generate(final TestBaseQuery query, final long rs) {
    final String op = getInstructionName(query);
    return generate(query, Collections.singletonMap(op + ".rs", rs));
  }

  protected static TestDataProvider generate(final TestBaseQuery query, final long rs, final long rt) {
    final String op  = getInstructionName(query);
    final Map<String, Long> values = new HashMap<>();
    values.put(op + ".rs", rs);
    values.put(op + ".rt", rt);

    return generate(query, values);
  }

  private static String getInstructionName(final TestBaseQuery query) {
    return query.getContext().get(TestBaseContext.INSTRUCTION);
  }

  private static TestDataProvider generate(final TestBaseQuery query, final Map<String, Long> values) {
    InvariantChecks.checkNotNull(query);
    InvariantChecks.checkNotNull(values);

    final Map<String, Node> unknowns = Utils.extractUnknown(query);
    final Map<String, Node> bindings = new LinkedHashMap<>();

    for (final Map.Entry<String, Node> entry : unknowns.entrySet()) {
      final String name = entry.getKey();

      if (values.containsKey(name)) {
        final long value = values.get(name); 
        final DataType type = entry.getValue().getDataType();
        final BitVector data = BitVector.valueOf(value, type.getSize());

        bindings.put(name, NodeValue.newBitVector(data));
      }
    }

    return TestDataProvider.singleton(new TestData(bindings));
  }
}
