/*
 * Copyright 2017 ISP RAS (http://www.ispras.ru)
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
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
import ru.ispras.testbase.TestBaseContext;
import ru.ispras.testbase.TestBaseQuery;
import ru.ispras.testbase.TestData;
import ru.ispras.testbase.TestDataProvider;
import ru.ispras.testbase.generator.Utils;
import ru.ispras.microtesk.test.engine.branch.BranchDataGenerator;
import ru.ispras.microtesk.test.engine.branch.BranchEngine;

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
    return query.getContext().get(TestBaseContext.INSTRUCTION).toString();
  }

  private static TestDataProvider generate(final TestBaseQuery query, final Map<String, Long> values) {
    InvariantChecks.checkNotNull(query);
    InvariantChecks.checkNotNull(values);

    final Map<String, Node> unknowns = Utils.extractUnknown(query);
    final Map<String, Object> bindings = new LinkedHashMap<>();

    for (final Map.Entry<String, Node> entry : unknowns.entrySet()) {
      final String name = entry.getKey();

      if (values.containsKey(name)) {
        final long value = values.get(name); 
        final DataType type = entry.getValue().getDataType();
        final BitVector data = BitVector.valueOf(value, type.getSize());

        bindings.put(name, NodeValue.newBitVector(data));
      }
    }

    return TestDataProvider.singleton(new TestData(BranchEngine.ID, bindings));
  }
}
