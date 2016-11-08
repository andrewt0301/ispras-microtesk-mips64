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

import ru.ispras.testbase.TestBaseQuery;
import ru.ispras.testbase.TestDataProvider;

/**
 * {@link MipsGotoDataGenerator} is a test data generator for unconditional branch instruction.
 */
public final class MipsGotoDataGenerator extends MipsBranchDataGenerator {
  @Override
  public TestDataProvider generateThen(final TestBaseQuery query) {
    throw new UnsupportedOperationException();
  }

  @Override
  public TestDataProvider generateElse(final TestBaseQuery query) {
    throw new UnsupportedOperationException();
  }
}
