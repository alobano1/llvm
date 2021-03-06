//=- VectorComputeUtil.cpp - vector compute utilities implemetation * C++ -*-=//
//
//                     The LLVM/SPIR-V Translator
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
// Copyright (c) 2020 Intel Corporation. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal with the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimers.
// Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimers in the documentation
// and/or other materials provided with the distribution.
// Neither the names of Intel Corporation, nor the names of its
// contributors may be used to endorse or promote products derived from this
// Software without specific prior written permission.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// CONTRIBUTORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS WITH
// THE SOFTWARE.
//
//===----------------------------------------------------------------------===//
//
// This file implements translation of VC float control bits
//
//===----------------------------------------------------------------------===//

#include "VectorComputeUtil.h"
#include "SPIRVInternal.h"
#include "llvm/IR/Metadata.h"
using namespace VectorComputeUtil;
using namespace SPIRV;

enum VCFloatControl {
  VC_RTE = 0,      // Round to nearest or even
  VC_RTP = 1 << 4, // Round towards +ve inf
  VC_RTN = 2 << 4, // Round towards -ve inf
  VC_RTZ = 3 << 4, // Round towards zero

  VC_DENORM_FTZ = 0,            // Denorm mode flush to zero
  VC_DENORM_D_ALLOW = 1 << 6,   // Denorm mode double allow
  VC_DENORM_F_ALLOW = 1 << 7,   // Denorm mode float allow
  VC_DENORM_HF_ALLOW = 1 << 10, // Denorm mode half allow

  VC_FLOAT_MODE_IEEE = 0, // Single precision float IEEE mode
  VC_FLOAT_MODE_ALT = 1   // Single precision float ALT mode
};

enum VCFloatControlMask {
  VC_ROUND_MASK = (VC_RTE | VC_RTP | VC_RTN | VC_RTZ),
  VC_FLOAT_MASK = (VC_FLOAT_MODE_IEEE | VC_FLOAT_MODE_ALT)
};

typedef SPIRVMap<VCRoundMode, VCFloatControl> VCRoundModeControlBitMap;
typedef SPIRVMap<VCFloatMode, VCFloatControl> VCFloatModeControlBitMap;
typedef SPIRVMap<VCFloatType, VCFloatControl> VCFloatTypeDenormMaskMap;
template <> inline void SPIRVMap<VCRoundMode, VCFloatControl>::init() {
  add(RTE, VC_RTE);
  add(RTP, VC_RTP);
  add(RTN, VC_RTN);
  add(RTZ, VC_RTZ);
}
template <> inline void SPIRVMap<VCFloatMode, VCFloatControl>::init() {
  add(IEEE, VC_FLOAT_MODE_IEEE);
  add(ALT, VC_FLOAT_MODE_ALT);
}
template <> inline void SPIRVMap<VCFloatType, VCFloatControl>::init() {
  add(Double, VC_DENORM_D_ALLOW);
  add(Float, VC_DENORM_F_ALLOW);
  add(Half, VC_DENORM_HF_ALLOW);
}

namespace VectorComputeUtil {

VCRoundMode getVCRoundMode(unsigned FloatControl) noexcept {
  return VCRoundModeControlBitMap::rmap(
      VCFloatControl(VC_ROUND_MASK & FloatControl));
}

VCDenormMode getVCDenormPreserve(unsigned FloatControl,
                                 VCFloatType FloatType) noexcept {
  VCFloatControl DenormMask =
      VCFloatTypeDenormMaskMap::map(FloatType); // 1 Bit mask
  return (DenormMask == (DenormMask & FloatControl)) ? Preserve : FlushToZero;
}

VCFloatMode getVCFloatMode(unsigned FloatControl) noexcept {
  return VCFloatModeControlBitMap::rmap(
      VCFloatControl(VC_FLOAT_MASK & FloatControl));
}

unsigned getVCFloatControl(VCRoundMode RoundMode) noexcept {
  return VCRoundModeControlBitMap::map(RoundMode);
}
unsigned getVCFloatControl(VCFloatMode FloatMode) noexcept {
  return VCFloatModeControlBitMap::map(FloatMode);
}
unsigned getVCFloatControl(VCDenormMode DenormMode,
                           VCFloatType FloatType) noexcept {
  if (DenormMode == Preserve)
    return VCFloatTypeDenormMaskMap::map(FloatType);
  return VC_DENORM_FTZ;
}

SPIRVStorageClassKind
getVCGlobalVarStorageClass(SPIRAddressSpace AddressSpace) noexcept {
  switch (AddressSpace) {
  case SPIRAS_Private:
    return StorageClassPrivate;
  case SPIRAS_Local:
    return StorageClassWorkgroup;
  default:
    assert(false && "Unexpected address space");
    return StorageClassPrivate;
  }
}

SPIRAddressSpace
getVCGlobalVarAddressSpace(SPIRVStorageClassKind StorageClass) noexcept {
  switch (StorageClass) {
  case StorageClassPrivate:
    return SPIRAS_Private;
  case StorageClassWorkgroup:
    return SPIRAS_Local;
  default:
    assert(false && "Unexpected storage class");
    return SPIRAS_Private;
  }
}

} // namespace VectorComputeUtil
